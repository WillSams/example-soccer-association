import { ApolloServer, ApolloError } from 'apollo-server-express';
import jwt from 'jsonwebtoken';

import { typeDefs } from './typeDefs.js';
import resolvers from './resolvers/index.js';

const initGqlServer = async (app) => {
  const server = new ApolloServer({
    typeDefs,
    resolvers,
    context: ({ req }) => {
      const token = req?.headers?.authorization?.replace('Bearer ', '');
      try {
        const decoded = jwt.verify(token, process.env.TOKEN_SECRET);
        const user = decoded;
        return { user };
      } catch (error) {
        const message =
          'You are not authorized to make requests to this API\'s GraphQL endpoints';
        throw new ApolloError(message, null);
      }
    },
    formatError: (err) => err.message,
    debug: process.env.NODE_ENV !== 'production',
  });

  await server.start();

  const apolloRegistration = {
    app,
    path: '/api/graphql',
    cors: true,
    bodyParserConfig: false,
  };
  server.applyMiddleware(apolloRegistration);
};

export default initGqlServer;
