import express from 'express';

const app: express.Express = express();

app.use('/static', express.static(`${__dirname}/static`));

app.get('/*', (_, res) => {
  res.sendFile(`${__dirname}/index.html`);
});

const port = 8080;

app.listen(port, () => console.log(`
  Node Express Listening at http://localhost:${port}
`));
