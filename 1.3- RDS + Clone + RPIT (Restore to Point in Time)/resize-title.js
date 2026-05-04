'use strict';

/** @type {import('sequelize-cli').Migration} */
'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn('Tarefas', 'titulo', {
      type: Sequelize.STRING(200),
      allowNull: false,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.changeColumn('Tarefas', 'titulo', {
      type: Sequelize.STRING(255),
      allowNull: false,
    });
  }
};
