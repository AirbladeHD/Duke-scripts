-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 11. Dez 2021 um 15:25
-- Server-Version: 10.4.21-MariaDB
-- PHP-Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `fivem`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `apps`
--

CREATE TABLE `apps` (
  `id` int(11) NOT NULL,
  `icon` text NOT NULL,
  `html` longtext NOT NULL,
  `js` longtext NOT NULL,
  `clientlua` longtext NOT NULL,
  `serverlua` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `apps`
--

INSERT INTO `apps` (`id`, `icon`, `html`, `js`, `clientlua`, `serverlua`) VALUES
(1, 'car.png', '<div id=\"bg\" style=\"background-color: green; width: 100%; height: 100%;\">\r\n<h1>Auto spawnen</h1>\r\nAutoname: <input type=\'text\' value=\'Baller\' id=\'name\'>\r\n<button id=\'submit\'>Spawnen</button>\r\n<script>\r\n    $(function() {\r\n        $(\'#submit\').on(\'click\', function(e) {\r\n            e.preventDefault(); closePhone();\r\n            $.post(\"http://Phone/spawncar\", JSON.stringify({\r\n                car: $(\'#name\').val()\r\n            }));\r\n\r\n        })\r\n    });\r\n</script>\r\n</div>', '', 'RegisterNUICallback(\'spawncar\', function(data)\r\n    local ModelHash = GetHashKey(data.car)\r\n    if not IsModelInCdimage(ModelHash) then return end\r\n    RequestModel(ModelHash)\r\n    while not HasModelLoaded(ModelHash) do\r\n        Citizen.Wait(10)\r\n    end\r\n    local ped = GetPlayerPed(-1)\r\n    local pc = GetEntityCoords(ped)\r\n    local _Vehicle = CreateVehicle(ModelHash, pc.x, pc.y, pc.z, 0, 0, 77.42708, false, false)\r\n    SetEntityRotation(_Vehicle, -0.01, -0.02, 23.45)\r\n    SetVehicleCustomPrimaryColour(_Vehicle, 255, 255, 255)\r\n    SetVehicleCustomSecondaryColour(_Vehicle, 255, 255, 255)\r\n    SetVehicleOnGroundProperly(_Vehicle)\r\n    SetModelAsNoLongerNeeded(ModelHash)\r\n    TaskWarpPedIntoVehicle(PlayerPedId(), _Vehicle, -1)\r\n  end)', ''),
(2, 'discord.png', '<iframe src=\"https://discordapp.com/widget?id=917868895661068359&theme=dark\" width=\"100%\" height=\"100%\" allowtransparency=\"true\" frameborder=\"0\" sandbox=\"allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts\"></iframe>', '', '', ''),
(5, 'youtube.png', '<iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/zvqa8X-0tBA\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>', '', '', ''),
(6, 'contacts.png', '<style>\r\n.holds-the-iframe {\r\n  background:url(loader.gif) center center no-repeat;\r\n}\r\n</style>\r\n<div class=\"holds-the-iframe\" id=\"loader\"><iframe style=\"border: 0px;\" width=\"100%\" height=\"100%\" id=\"app\" src=\"http://localhost/Anrufe/build/web/index.html\"></iframe></div>', '\r\n            function postToFlutter(msg) {\r\n                var el = document.getElementById(\"app\");\r\n                el.contentWindow.postMessage(msg,\"*\");\r\n            } \r\n        $(function() {\r\n                \r\n                window.addEventListener(\"message\", (event) => {\r\n                    \r\n                    var item = event.data;\r\n                    if (item == \"loaded\") {\r\n                        $.post(\"http://Phone/sendcontacts\", JSON.stringify({}));\r\n                    } else if (item.toString().includes(\"flutter\")){\r\n                        postToFlutter(item);\r\n                    }\r\n                });\r\n                \r\n                \r\n        });', '\r\nRegisterNUICallback(\"sendcontacts\", function()\r\n    local _calls = {{name=\"Julian\", nr=\"55343434\", datum=\"09.03.2021 12:31\", eingehend=\"false\"}, {name=\"Markus\", nr=\"123456\", datum=\"10.10.2021 15:45\", eingehend=\"true\"}, {name=\"Michi\", nr=\"236423\", datum=\"10.12.2021 11:15\", eingehend=\"false\"}}\r\n    local data ={dest=\"flutter\", calls = _calls, contacts = {{name=\"Mike\", nr=\"015236641565\"}, {name=\"Zuhause\", nr=\"03077392593\"}, {name=\"Auskunft\", nr=\"11880\"}, {name=\"Taxiservice\", nr=\"0800223344\"}, {name=\"Mandy\", nr=\"017688464\"}}}\r\n    SendNUIMessage(json.encode(data))\r\nend) 	', '');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `player_apps`
--

CREATE TABLE `player_apps` (
  `pkey` int(11) NOT NULL,
  `license` varchar(255) NOT NULL,
  `appId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `player_apps`
--

INSERT INTO `player_apps` (`pkey`, `license`, `appId`) VALUES
(15, 'license:8e431aa7144479bea5a5143f26caab5c4116d267', 1),
(16, 'license:8e431aa7144479bea5a5143f26caab5c4116d267', 2),
(17, 'license:8e431aa7144479bea5a5143f26caab5c4116d267', 5),
(18, 'license:8e431aa7144479bea5a5143f26caab5c4116d267', 6);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `apps`
--
ALTER TABLE `apps`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `player_apps`
--
ALTER TABLE `player_apps`
  ADD PRIMARY KEY (`pkey`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `apps`
--
ALTER TABLE `apps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `player_apps`
--
ALTER TABLE `player_apps`
  MODIFY `pkey` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
