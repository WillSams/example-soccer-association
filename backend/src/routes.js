import { aboutHandler } from './handlers/about.js';
import { tokenHandler } from './handlers/token.js';

const routes = (app) => {
  [
    app.options('{*path}', (_req, res) => res.status(200).send()),
    app.get('/api/about', aboutHandler),
    app.get('/api/token', tokenHandler),
  ];
};

export default routes;
