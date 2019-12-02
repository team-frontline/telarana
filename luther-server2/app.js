const express = require('express');
const app = express();

const assetRoutes = require('./api/routes/asset');

app.use('/api', assetRoutes);

module.exports = app;