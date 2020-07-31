## Facts Node Server
#### To build the server, follow the given instruction

1. Clone the repository and switch to 'BackEnd' directory.
```
git clone https://github.com/mundhrakeshav/Facts-Eureka-HackFS
cd BackEnd
```
2. To install the required modules, run
```
npm install
```
3. To source code is written in TypeScript is placed in the 'app' directory.
4. The source code is converted to JavaScript and is placed in the 'build' directory.
5. To build the source code, run
```
npm run tsc
```
This command will convert the TypeScript file to JavaScript file

6. Now, you are ready to start the server. Run the following command
```
node build/app.js
```
Voila! The server apis will be accessible at https://localhost:5000
