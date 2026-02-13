
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Наше Дерево Любви</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background-color: #fdf0f0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        #timer-container {
            position: absolute;
            top: 20px;
            left: 20px;
            text-align: center;
            z-index: 10;
            background: rgba(255, 255, 255, 0.9);
            padding: 15px 25px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid #ffcfdf;
            opacity: 0;
            transition: opacity 0.5s ease;
        }
        
        #timer-container.show {
            opacity: 1;
        }

        h1 { color: #d63384; margin: 0 0 5px 0; font-size: 24px; }
        #timer { font-size: 20px; color: #555; font-weight: bold; }

        #loveButton {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 20px 50px;
            font-size: 24px;
            font-weight: bold;
            color: white;
            background: linear-gradient(135deg, #d63384 0%, #ff1493 100%);
            border: none;
            border-radius: 50px;
            cursor: pointer;
            box-shadow: 0 8px 25px rgba(214, 51, 132, 0.4);
            transition: all 0.3s ease;
            z-index: 20;
        }

        #loveButton:hover {
            transform: translate(-50%, -50%) scale(1.05);
            box-shadow: 0 12px 35px rgba(214, 51, 132, 0.6);
        }

        #loveButton:active {
            transform: translate(-50%, -50%) scale(0.98);
        }

        #loveButton.hidden {
            display: none;
        }

        #animatedText {
            position: absolute;
            top: 225px;
            left: 70px;
            font-size: 24px;
            color: #d63384;
            font-weight: 500;
            line-height: 1.6;
            min-height: 80px;
            width: 700px;
            font-family: 'Trebuchet MS', 'Segoe UI', sans-serif;
            opacity: 0;
            transition: opacity 0.5s ease;
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        #animatedText.show {
            opacity: 1;
        }

        canvas {
            display: block;
        }
    </style>
</head>
<body>

    <div id="timer-container">
        <h1>Мы вместе уже:</h1>
        <div id="timer">Загрузка...</div>
    </div>

    <div id="animatedText"></div>

    <button id="loveButton">Жми</button>

    <canvas id="treeCanvas"></canvas>

    <script>
        // --- НАСТРОЙКИ ---
        // Формат: ГГГГ, МЕСЯЦ (0-11), ДЕНЬ. 4 — это май, так как отсчет с нуля.
        const startDate = new Date(2025, 4, 30, 0, 0, 0);
        
        // Анимация роста дерева
        const animationDuration = 3000; // 3 секунды
        let animationStartTime = null;
        let treeAnimationStarted = false; 
        
        function updateTimer() {
            const now = new Date();
            const diff = now - startDate;

            if (diff < 0) {
                document.getElementById('timer').innerHTML = "Всё еще впереди!";
                return;
            }

            const days = Math.floor(diff / (1000 * 60 * 60 * 24));
            const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
            const minutes = Math.floor((diff / 1000 / 60) % 60);
            const seconds = Math.floor((diff / 1000) % 60);

            document.getElementById('timer').innerHTML = 
                `${days}д : ${hours}ч : ${minutes}м : ${seconds}с`;
        }
        setInterval(updateTimer, 1000);
        updateTimer();

        // --- ДЕРЕВО ---
        const canvas = document.getElementById('treeCanvas');
        const ctx = canvas.getContext('2d');

        function resize() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            render();
        }

        function drawHeart(x, y, size, color = "#ff6b6b") {
            ctx.beginPath();
            ctx.moveTo(x, y);
            ctx.bezierCurveTo(x, y - size/2, x - size, y - size/2, x - size, y);
            ctx.bezierCurveTo(x - size, y + size/2, x, y + size, x, y + size);
            ctx.bezierCurveTo(x, y + size, x + size, y + size/2, x + size, y);
            ctx.bezierCurveTo(x + size, y - size/2, x, y - size/2, x, y);
            ctx.fillStyle = color;
            ctx.fill();
            ctx.closePath();
        }

        function drawGround() {
            // Земля
            ctx.fillStyle = "#8b7355";
            ctx.fillRect(0, canvas.height - 40, canvas.width, 40);
            
            // Трава сверху (без движения)
            ctx.fillStyle = "#6b9e4d";
            ctx.fillRect(0, canvas.height - 45, canvas.width, 5);
            
            // Детали травы (статичные)
            ctx.fillStyle = "#5a8d3f";
            for (let i = 0; i < canvas.width; i += 40) {
                ctx.beginPath();
                ctx.arc(i + 15, canvas.height - 43, 2, 0, Math.PI * 2);
                ctx.fill();
            }
            
            // Дополнительные детали почвы (статичные)
            ctx.fillStyle = "#a0826d";
            for (let i = 0; i < canvas.width; i += 50) {
                ctx.beginPath();
                ctx.arc(i + 25, canvas.height - 20, 2, 0, Math.PI * 2);
                ctx.fill();
            }
        }
        
        function drawHill(centerX, centerY) {
            // Рисуем холм/возвышенность для скрытия основания дерева (только верхнюю часть)
            ctx.fillStyle = "#6b9e4d";
            ctx.beginPath();
            // Рисуем только верхнюю половину овала
            ctx.ellipse(centerX, centerY, 160, 35, 0, Math.PI, 0);
            ctx.lineTo(centerX + 160, centerY);
            ctx.lineTo(centerX - 160, centerY);
            ctx.fill();
            
            // Травяной слой только снаружи холма (края)
            ctx.fillStyle = "#5a8d3f";
            ctx.beginPath();
            ctx.arc(centerX - 130, centerY - 2, 3, 0, Math.PI * 2);
            ctx.fill();
            ctx.beginPath();
            ctx.arc(centerX + 130, centerY - 2, 3, 0, Math.PI * 2);
            ctx.fill();
        }
        
        function drawSky() {
            // Голубое небо с градиентом
            const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
            gradient.addColorStop(0, '#87ceeb'); // Легкое голубое сверху
            gradient.addColorStop(1, '#e0f6ff'); // Побледнее снизу
            ctx.fillStyle = gradient;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
        }
        
        function drawCloud(x, y, size) {
            // Облако из объединенных кругов
            ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
            
            ctx.beginPath();
            ctx.arc(x, y, size * 0.6, 0, Math.PI * 2);
            ctx.fill();
            
            ctx.beginPath();
            ctx.arc(x + size * 0.6, y, size * 0.5, 0, Math.PI * 2);
            ctx.fill();
            
            ctx.beginPath();
            ctx.arc(x - size * 0.6, y, size * 0.5, 0, Math.PI * 2);
            ctx.fill();
            
            ctx.beginPath();
            ctx.arc(x + size * 1.2, y - size * 0.3, size * 0.4, 0, Math.PI * 2);
            ctx.fill();
        }
        
        function drawClouds(cloudOffset) {
            // Облака которые двигаются вправо
            const cloudPositions = [
                { x: 100, y: 80, size: 60 },
                { x: 350, y: 120, size: 52 },
                { x: 600, y: 90, size: 57 },
                { x: 850, y: 110, size: 60 },
                { x: 1100, y: 100, size: 54 },
                { x: -100, y: 100, size: 54 },
                { x: 200, y: 60, size: 48 },
                { x: 500, y: 140, size: 55 },
                { x: 750, y: 70, size: 50 },
                { x: 1000, y: 130, size: 58 },
                { x: -50, y: 80, size: 52 }
            ];
            
            cloudPositions.forEach(cloud => {
                // Движим облаки вправо с медленным движением (бесконечно)
                const x = (cloud.x + cloudOffset) % (canvas.width + 300);
                drawCloud(x, cloud.y, cloud.size);
            });
        }
        
        function drawTrunk(x, y, animationProgress) {
            if (animationProgress < 0.2) return; // Ствол появляется первым
            
            const alpha = Math.min(1, (animationProgress - 0.2) / 0.3);
            ctx.globalAlpha = alpha;
            
            // Рисуем корни (плавный переход с земли)
            ctx.strokeStyle = "#3d2817";
            ctx.lineWidth = 8;
            ctx.lineCap = "round";
            
            // Левый корень
            ctx.beginPath();
            ctx.moveTo(x - 20, y);
            ctx.quadraticCurveTo(x - 40, y + 20, x - 45, y + 35);
            ctx.stroke();
            
            // Правый корень
            ctx.beginPath();
            ctx.moveTo(x + 20, y);
            ctx.quadraticCurveTo(x + 40, y + 20, x + 45, y + 35);
            ctx.stroke();
            
            // Центральный ствол (толстый)
            ctx.strokeStyle = "#2d2416";
            ctx.lineWidth = 40; // Толщина ствола
            ctx.lineCap = "round";
            
            ctx.beginPath();
            ctx.moveTo(x, y + 35);
            ctx.lineTo(x, y - 150);
            ctx.stroke();
            
            // Тень на стволе для объёма
            ctx.strokeStyle = "rgba(0, 0, 0, 0.2)";
            ctx.lineWidth = 15;
            ctx.beginPath();
            ctx.moveTo(x - 15, y + 35);
            ctx.lineTo(x - 15, y - 150);
            ctx.stroke();
            
            ctx.globalAlpha = 1;
        }
        
        function drawTree(startX, startY, len, angle, branchWidth, animationProgress, depth = 0) {
            // Если длина ветки не достигла по прогрессу анимации, не рисуем
            if (len > animationProgress * 160) {
                len = Math.max(0, animationProgress * 160 - (160 - len));
                if (len <= 0) return;
            }
            
            ctx.beginPath();
            ctx.save();
            ctx.strokeStyle = "#1a1a1a";
            ctx.lineWidth = branchWidth;
            ctx.translate(startX, startY);
            ctx.rotate(angle * Math.PI/180);
            ctx.moveTo(0, 0);
            ctx.lineTo(0, -len);
            ctx.stroke();

            // Если ветка стала очень короткой, рисуем сердечки (листья)
            if (len < 15) {
                // Детерминированная рандомизация на основе координат
                const seed = Math.floor(startX * 0.01 + startY * 0.02 + angle);
                const seededRandom = (index) => {
                    const x = Math.sin(seed + index) * 10000;
                    return x - Math.floor(x);
                };
                
                // Разные размеры и цвета сердечек
                const colors = ["#ff1744", "#ff5252", "#ff6e6e", "#ff8a8a", "#ffb3b3", "#ffc0c0"];
                const randomColor = colors[Math.floor(seededRandom(1) * colors.length)];
                const randomSize = 6 + seededRandom(2) * 5; // От 6 до 11
                
                drawHeart(0, -len, randomSize, randomColor);
                
                // Добавляем больше сердечек рядом для пышности (детерминировано)
                if (seededRandom(3) > 0.2) {
                    const offsetX1 = (seededRandom(4) - 0.5) * 12;
                    const offsetY1 = (seededRandom(5) - 0.5) * 10;
                    const size1 = 4 + seededRandom(6) * 4;
                    drawHeart(offsetX1, -len + offsetY1, size1, colors[Math.floor(seededRandom(7) * colors.length)]);
                }
                if (seededRandom(8) > 0.2) {
                    const offsetX2 = (seededRandom(9) - 0.5) * 12;
                    const offsetY2 = (seededRandom(10) - 0.5) * 10;
                    const size2 = 4 + seededRandom(11) * 4;
                    drawHeart(offsetX2, -len + offsetY2, size2, colors[Math.floor(seededRandom(12) * colors.length)]);
                }
                if (seededRandom(13) > 0.3) {
                    const offsetX3 = (seededRandom(14) - 0.5) * 15;
                    const offsetY3 = (seededRandom(15) - 0.5) * 12;
                    const size3 = 3 + seededRandom(16) * 3;
                    drawHeart(offsetX3, -len + offsetY3, size3, colors[Math.floor(seededRandom(17) * colors.length)]);
                }
                
                ctx.restore();
                return;
            }

            // Углы наклона веток
            let curve1, curve2;
            
            if (depth < 2) {
                // Верхние ветки - широкое раскрытие
                curve1 = 40;
                curve2 = 40;
            } else if (depth < 3) {
                curve1 = 35;
                curve2 = 35;
            } else {
                curve1 = 30;
                curve2 = 30;
            }

            // Рекурсивное рисование
            drawTree(0, -len, len * 0.72, angle - curve1, branchWidth * 0.75, animationProgress, depth + 1);
            drawTree(0, -len, len * 0.72, angle + curve2, branchWidth * 0.75, animationProgress, depth + 1);
            
            // Дополнительные ветки только на верхних уровнях (убрали из нижних)
            if (depth < 1 && len > 50) {
                drawTree(0, -len * 0.5, len * 0.55, angle - 20, branchWidth * 0.65, animationProgress, depth + 1);
                drawTree(0, -len * 0.5, len * 0.55, angle + 20, branchWidth * 0.65, animationProgress, depth + 1);
            }

            ctx.restore();
        }
        
        // Функция для постепенного показа текста
        function typeText(text, elementId, interval = 500) {
            const element = document.getElementById(elementId);
            element.innerHTML = '';
            element.classList.add('show');
            let index = 0;
            
            const typeInterval = setInterval(() => {
                if (index < text.length) {
                    element.innerHTML += text[index];
                    index++;
                } else {
                    clearInterval(typeInterval);
                }
            }, interval);
        }
        
        // Обработчик кнопки "Полюбить"
        document.getElementById('loveButton').addEventListener('click', function() {
            this.classList.add('hidden');
            document.getElementById('timer-container').classList.add('show');
            treeAnimationStarted = true;
            animationStartTime = null; // Сбрасываем время анимации
            
            // Запускаем появление текста с задержкой
            const loveText = 'Ты — моё самое драгоценное сокровище и светлячок моего сердца, который зажёг в нём огонёк любви. Я люблю тебя больше, чем ты можешь себе представить, и с каждым утром это чувство становится только сильнее';
            typeText(loveText, 'animatedText', 100);
            
            render();
        });

        function render() 
        {
            // Если анимация не начата, не рисуем
            if (!treeAnimationStarted) {
                requestAnimationFrame(render);
                return;
            }
            
            // Инициализируем время анимации при первом вызове
            if (animationStartTime === null) {
                animationStartTime = Date.now();
            }
            
            // Вычисляем прогресс анимации (от 0 до 1)
            const elapsed = Date.now() - animationStartTime;
            const animationProgress = Math.min(1, elapsed / animationDuration);
            
            // Вычисляем смещение облаков (медленное движение)
            const cloudOffset = (Date.now() / 50) % (canvas.width + 200);
            
            // Рисуем небо
            drawSky();
            
            // Рисуем облака
            drawClouds(cloudOffset);
            
            // Рисуем землю
            drawGround();
            
            const treeX = canvas.width / 2 + 100;
            const treeY = canvas.height - 40;
            // Угол 15 - наклон дерева влево
            drawTree(treeX, treeY, 160, 15, 14, animationProgress, 0);
            
            // Рисуем холм после дерева чтобы он был впереди
            drawHill(treeX, treeY - 5);
            
            // Продолжаем анимацию бесконечно для облаков
            requestAnimationFrame(render);
        }
            
        window.addEventListener('resize', resize);
        resize(); // Первый запуск
    </script>
</body>
</html>
