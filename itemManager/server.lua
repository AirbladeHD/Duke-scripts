function hash(string, hashLen)

    --Testen ob die übergebene Bytelänge ein Vielfaches von 16 ist

    if math.fmod(hashLen, 16) ~= 0 then
        return "Hash error: Die Bytelänge sollte aus Sicherheitsgründen ein Vielfaches von 16 sein!"
    end

    --String in eine Bytefolge umrechnen

    byte = nil

    for i = 1, #string, 1 do
        if byte ~= nil then
            byte = byte..string.byte(string.sub(string, i, i))
        else
            byte = string.byte(string.sub(string, i, i))
        end
    end

    --Falls die Bytefolge kleiner als die angebene Bytelänge ist, wird sie hochgerechnet

    if #byte < hashLen then
        while #byte < hashLen do
            local lastChar = tonumber(string.sub(byte, -4, -1))
            local secLastChar = tonumber(string.sub(byte, -8, -4))
            if lastChar == 0 then
                lastChar = tonumber(string.sub(byte, 1, 4))
            end
            if secLastChar == 0 then
                secLastChar = tonumber(string.sub(byte, 4, 8))
            end
            newChar = lastChar + secLastChar
            byte = byte..tonumber(newChar)
        end
    end
    
    --Falls die Bytefolge größer als die angebene Bytelänge ist, wird sie heruntergerechnet

    if #byte > hashLen then
        while #byte > hashLen do
            local lastChar = tonumber(string.sub(byte, -1))
            local secLastChar = tonumber(string.sub(byte, -2, -2))
            if lastChar == 0 then
                lastChar = 1
            end
            if secLastChar == 0 then
                secLastChar = 1
            end
            if lastChar > secLastChar then
                newChar = lastChar - secLastChar
            else
                newChar = secLastChar - lastChar
            end
            byteSub = string.sub(byte, -2):reverse()
            byte = byte:reverse()
            byte = byte:gsub(byteSub, newChar, 1)
            byte = byte:reverse()
        end
    end
    
    --Berechne die Anzahl der Blöcke und erstelle eine Tabelle mit den Blöcken aus der Bytefolge

    blockCount = math.ceil(hashLen / 16)
    block = {}
    index = 1
    counter = 1
    
    while index < hashLen do
        table.insert(block, byte:sub(index, math.ceil(counter * blockCount)))
        index = index + blockCount
        counter = counter + 1
    end

    --Berechne die Quersumme aus den einzelnen Blöcken (Falls kleiner als 1000 -> +1000) und übersetze sie in Hexadezimal
    --Falls der bisherige Hashwert noch nicht existiert, erstelle ihn und hänge den Namen des Algorithmus und die verwendete Bytelänge an
    
    hex = nil
    checksum = nil

    for i = 1, #block, 1 do
        for c = 1, #block[i], 1 do
            if checksum ~= nil then
                checksum = checksum + tonumber(string.sub(block[i], c, c))
            else
                checksum = tonumber(string.sub(block[i], c, c))
            end
        end
        if checksum < 1000 then
            checksum = checksum + 1000
        end
        blockHex = string.format("%x", checksum)
        if hex == nil then
            hex = "duke"..hashLen.."$"..tostring(blockHex)
        else
            hex = hex..tostring(blockHex)
        end
    end

    return hex
end

print(hash("Hallo Welt", 512))