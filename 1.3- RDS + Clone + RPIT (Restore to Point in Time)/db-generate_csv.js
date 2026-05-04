const fs = require('fs');
const { randomUUID } = require('crypto');

const numRecords = 2000000;
const totalFiles = 5;
const now = new Date().toISOString();

function generateFile(fileIndex) {
    return new Promise((resolve) => {
        const stream = fs.createWriteStream(`data-${fileIndex}.csv`);
        let i = 0;

        function write() {
            let ok = true;

            while (i < numRecords && ok) {
                const uuid = randomUUID();
                const titulo = `Tarefa ${i}`;
                const dia_atividade = `2024-01-01`;
                const importante = Math.random() < 0.5;

                ok = stream.write(
                    `${uuid},${titulo},${dia_atividade},${importante},${now},${now}\n`
                );

                i++;
            }

            if (i < numRecords) {
                stream.once('drain', write);
            } else {
                stream.end();
            }
        }

        stream.on('finish', resolve);
        write();
    });
}

async function run() {
    for (let f = 1; f <= totalFiles; f++) {
        console.log(`Gerando arquivo ${f}...`);
        await generateFile(f);
    }
    console.log('Todos os arquivos foram gerados!');
}

run();
