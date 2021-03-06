process.env.NODE_ENV = 'test';

const chai = require('chai');
const expect = chai.expect;

const { teamGames } = require('../../../src/resolvers/queries');
const { reseedDb } = require('../../../specs');

describe('Resolvers - Queries', () => {
  before(() => reseedDb());

  const params = { teamId: 'test-team-1' };

  it('`teamGames` query should retrieve games for given team', () => {
    teamGames(null, { ...params }).then(result => {
      expect(result).to.to.have.lengthOf(2);
    });
  });
});