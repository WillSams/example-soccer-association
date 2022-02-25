const isDevelopmentHost = () =>
  process.env.NODE_ENV === 'development' ? true : false;

const soccerTableName =
  process?.env?.NODE_ENV ? `Deportivo-${process?.env?.NODE_ENV}` : process?.env?.SOCCER_TABLE;

module.exports = {
  isDevelopmentHost,
  soccerTableName,
};