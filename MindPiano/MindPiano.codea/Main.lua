-- MindPiano
supportedOrientations(LANDSCAPE_ANY)
-- Use this function to perform your initial setup
function setup()
    touches = {}
    isBlink = false
    frequency = {4168.01,3951.07,3729.31,3520.00,3322.44,3135.96,2959.96,2793.83,2637.02,2489.02,2349.32,2217.46,2093.00,1975.53,1864.66,1760.00,1661.22,1567.98,1479.98,1396.91,1318.51,1244.51,1174.66,1108.73,1046.50,987.767,932.328,880.000,830.609,783.991,739.989,698.456,659.255,622.254,587.330,554.365,523.251,493.883,466.164,440.000,415.305,391.995,369.994,349.228,329.628,311.127,293.665,277.183,261.626,246.942,233.082,220.000,207.652,195.998,184.997,174.614,164.814,155.563,146.832,138.591,130.813,123.471,116.541,110.000,103.826,97.9989,92.4986,87.3071,82.4069,77.7817,73.4162,69.2957,65.4064,61.7354,58.2705,55.0000,51.9131,48.9994,46.2493,43.6535,41.2034,38.8909,36.7081,34.6478,32.7032,30.8677,29.1352,27.5000}
    keyType = {false,true,false}
    
    two = true
    for i = 1,14 do
        temp = false
        if two then
            for k=1,5 do
                table.insert(keyType,temp)
                if temp then
                    temp = false
                else
                    temp=true
                end
            end
            two = false
        else
            for k =1,7 do
                table.insert(keyType,temp)
                if temp then
                    temp = false
                else
                    temp=true
                end
            end
            two = true
        end
    end
    table.insert(keyType,false)
    parameter.integer("current",1,#frequency)
    parameter.boolean("touchEnabled",true)
    spriteMode(CENTER)
    counter = 0
    
end

function touched(touch)
    if touch.state == ENDED then
        -- When any touch ends, remove it from
        --  our table
        touches[touch.id] = nil
    else
        -- If the touch is in any other state
        --  (such as BEGAN) we add it to our
        --  table
        touches[touch.id] = touch
    end
end

function countWhite()
    for i=1,88 do
        if keyType[i] == false then
            counter = counter + 1
        end
    end
    print(counter)
end

-- This function gets called once every frame
function draw()
    current = math.floor(mindwave.attention()/88)
    isBlink = mindwave.isBlink()
    -- This sets a dark background color
    background(199, 212, 203, 255)
    
    for k,touch in pairs(touches) do
        drawKey4(touch)
    end
    if #touches ==0 then
        drawKey4(CurrentTouch)
    end
    --sprite("Project:piano",WIDTH/2,HEIGHT/2,WIDTH)
    if isBlink then
        playKey(current)
    end
    fill(0)
    rect(0,HEIGHT*5/6,WIDTH,HEIGHT/6)
    fill(255)
    fontSize(WIDTH/15)
    text("Mind Piano",WIDTH/2,HEIGHT*5.35/6)
    --  if CurrentTouch.state == BEGAN and touchEnabled then
    --     playKey(readKey())
    -- end
    -- This sets the line thickness
    strokeWidth(5)
    -- Do your drawing here
    
end

function playKey(key)
    -- print(key)
    -- sound.stop()
    sound("Dropbox:SingleKey",1.0,frequency[key]/261.626)
end

function drawKey()
    x=0
    stroke(0)
    strokeWidth(1.0)
    for i=1,#keyType do
        fill(255, 255, 255, 0)
        y = 0
        rectMode(CORNER)
        if keyType[i] then
            fill(0)
            y=HEIGHT/4
            x = x - WIDTH/88/2*52/36
            --  rectMode(CENTER)
        end
        
        -- if i == current then
        --       fill(0, 202, 255, 255)
        --    end
        
        rect(x,y+HEIGHT/4,WIDTH/88*52/36,HEIGHT/2-y)
        
        x = x + WIDTH/88*52/36
        if keyType[i] then
            x = x - WIDTH/88/2*52/36
        end
        
    end
    
end

function drawKey2()
    stroke(0)
    strokeWidth(1.5)
    counter = 0
    for i=1,88 do
        fill(255)
        if i == current then
            fill(0, 202, 255, 255)
        end
        if keyType[i] == false then
            if touchEnabled and CurrentTouch.state == BEGAN then
                if i == 1 or i ==88 then
                    if i == 1 and CurrentTouch.x < WIDTH/52 then
                        playKey(1)
                        fill(186, 186, 186, 255)
                    elseif i == 88 and CurrentTouch.x > WIDTH-WIDTH/52 then
                        playKey(88)
                        fill(186, 186, 186, 255)
                    end
                else
                    if keyType[i+1] == false and keyType[i-1] == false then
                        if CurrentTouch.x > (counter)*WIDTH/52 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i-1] == false then
                        if CurrentTouch.x > (counter)*WIDTH/52 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4*3 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i+1] == false then
                        if CurrentTouch.x < (counter+1)*WIDTH/52 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x < (counter)*WIDTH/52+WIDTH/52/4 and CurrentTouch.x > (counter)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                    else
                        if CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4 then
                            if CurrentTouch.y < HEIGHT/2 then
                                playKey(i)
                                
                                fill(186, 186, 186, 255)
                            end
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4*3 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4*3 and CurrentTouch.x > (counter)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                        
                        
                    end
                end
                
            end
            rect((counter)*WIDTH/52,HEIGHT/4,WIDTH/52,HEIGHT/2)
            counter = counter + 1
        end
    end
    
    
    counter = 0
    for i=1,88 do
        fill(0)
        if i == current then
            fill(0, 202, 255, 255)
        end
        
        if keyType[i] == false then
            counter = counter + WIDTH/52
        end
        if keyType[i] then
            counter = counter - WIDTH/52/4
            if touchEnabled and CurrentTouch.state == BEGAN then
                if CurrentTouch.y > HEIGHT/4+HEIGHT/8 then
                    if CurrentTouch.x > counter and CurrentTouch.x < counter+WIDTH/52/2 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                    end
                end
            end
            rect(counter,HEIGHT/4+HEIGHT/8,WIDTH/52/2,HEIGHT/8*3)
            counter = counter +WIDTH/52/4
        end
        
    end
end


function drawKey3()
    stroke(0)
    strokeWidth(1.5)
    counter = 0
    yPush = 0
    xPush=0
    for i=1,88 do
        fill(255)
        if i == current then
            fill(0, 202, 255, 255)
        end
        if keyType[i] == false then
            if touchEnabled and CurrentTouch.state == BEGAN then
                if i == 1 or i ==88 then
                    if i == 1 and CurrentTouch.x < WIDTH/52*2 and CurrentTouch.y < HEIGHT/2 then
                        playKey(1)
                        fill(186, 186, 186, 255)
                    elseif i == 88 and CurrentTouch.x > WIDTH-WIDTH/52*2 and CurrentTouch.y > HEIGHT/2  then
                        playKey(88)
                        fill(186, 186, 186, 255)
                    end
                else
                    if keyType[i+1] == false and keyType[i-1] == false then
                        if CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i-1] == false then
                        if CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2*3 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i+1] == false then
                        if CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.x < (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                    else
                        if CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            --   if CurrentTouch.y < HEIGHT/2 then
                            playKey(i)
                            
                            fill(186, 186, 186, 255)
                            --     end
                        elseif CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*3*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*3*2 and CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                        
                        
                    end
                end
                
            end
            rect((counter+xPush)*WIDTH/52*2,HEIGHT/6+yPush,WIDTH/52*2,HEIGHT/3)
            if counter == 26 then
                yPush = yPush + HEIGHT/3
                xPush = xPush - 26
            end
            counter = counter + 1
        end
    end
    xPush=0
    yPush=0
    
    counter = 0
    for i=1,88 do
        fill(0)
        if i == current then
            fill(0, 202, 255, 255)
        end
        
        if keyType[i] == false then
            counter = counter + WIDTH/52*2
        end
        if keyType[i] then
            counter = counter - WIDTH/52/4*2
            if touchEnabled and CurrentTouch.state == BEGAN then
                if CurrentTouch.y > HEIGHT/6+HEIGHT/12+yPush and CurrentTouch.y <HEIGHT/2+yPush then
                    if CurrentTouch.x > counter and CurrentTouch.x < counter+WIDTH/52/2*2 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                    end
                end
            end
            rect(counter,HEIGHT/6+HEIGHT/12+yPush,WIDTH/52,HEIGHT/12*3)
            counter = counter +WIDTH/52/4*2
            if counter>= WIDTH then
                counter = 0
                yPush = yPush + HEIGHT/3
            end
        end
        
    end
end

function readKey()
    x = 0
    for i =1,88 do
        if CurrentTouch.x > x and CurrentTouch.x < x+WIDTH/90 then
            return i
        end
        x = x + WIDTH/90
    end
    return 1
end

function readKey2()
    
end


function drawKey4(touch)
    stroke(0)
    strokeWidth(1.5)
    counter = 0
    yPush = 0
    xPush=0
    for i=1,88 do
        fill(255)
        if i == current then
            fill(0, 202, 255, 255)
        end
        if keyType[i] == false then
            if touchEnabled and touch.state == BEGAN then
                if i == 1 or i ==88 then
                    if i == 1 and touch.x < WIDTH/52*2 and touch.y < HEIGHT/2 then
                        playKey(1)
                        fill(186, 186, 186, 255)
                    elseif i == 88 and touch.x > WIDTH-WIDTH/52*2 and touch.y > HEIGHT/2  then
                        playKey(88)
                        fill(186, 186, 186, 255)
                    end
                else
                    if keyType[i+1] == false and keyType[i-1] == false then
                        if touch.x > (counter+xPush)*WIDTH/52*2 and touch.x < (counter+xPush+1)*WIDTH/52*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i-1] == false then
                        if touch.x > (counter+xPush)*WIDTH/52*2 and touch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif touch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2*3 and touch.x < (counter+xPush+1)*WIDTH/52*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i+1] == false then
                        if touch.x < (counter+xPush+1)*WIDTH/52*2 and touch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif touch.x < (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and touch.x > (counter+xPush)*WIDTH/52*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                    else
                        if touch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and touch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            --   if touch.y < HEIGHT/2 then
                            playKey(i)
                            
                            fill(186, 186, 186, 255)
                            --     end
                        elseif touch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*3*2 and touch.x < (counter+xPush+1)*WIDTH/52*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif touch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*3*2 and touch.x > (counter+xPush)*WIDTH/52*2 and touch.y>yPush+HEIGHT/6 and touch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                        
                        
                    end
                end
                
            end
            if i == 45 then
                yPush = yPush + HEIGHT/3
                xPush = xPush - 26
                print(counter)
            end
            rect((counter+xPush)*WIDTH/52*2,HEIGHT/6+yPush,WIDTH/52*2,HEIGHT/3)
            
            counter = counter + 1
        end
    end
    xPush=0
    yPush=0
    
    counter = 0
    for i=1,88 do
        fill(0)
        if i == current then
            fill(0, 202, 255, 255)
        end
        
        if keyType[i] == false then
            counter = counter + WIDTH/52*2
        end
        if keyType[i] then
            counter = counter - WIDTH/52/4*2
            if touchEnabled and touch.state == BEGAN then
                if touch.y > HEIGHT/6+HEIGHT/12+yPush and touch.y <HEIGHT/2+yPush then
                    if touch.x > counter and touch.x < counter+WIDTH/52/2*2 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                    end
                end
            end
            rect(counter,HEIGHT/6+HEIGHT/12+yPush,WIDTH/52,HEIGHT/12*3)
            counter = counter +WIDTH/52/4*2
            if counter>= WIDTH then
                counter = 0
                yPush = yPush + HEIGHT/3
            end
        end
        
    end
end


-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(199, 212, 203, 255)
    drawKey3()
    --sprite("Project:piano",WIDTH/2,HEIGHT/2,WIDTH)
    if isBlink then
        playKey(current)
    end
    fill(0)
    rect(0,HEIGHT*5/6,WIDTH,HEIGHT/6)
    fill(255)
    fontSize(WIDTH/15)
    text("Mind Piano",WIDTH/2,HEIGHT*5.35/6)
    --  if CurrentTouch.state == BEGAN and touchEnabled then
    --     playKey(readKey())
    -- end
    -- This sets the line thickness
    strokeWidth(5)
    -- Do your drawing here
    
end

function playKey(key)
    -- print(key)
    sound("Dropbox:SingleKey",1.0,frequency[key]/261.626)
end

function drawKey()
    x=0
    stroke(0)
    strokeWidth(1.0)
    for i=1,#keyType do
        fill(255, 255, 255, 0)
        y = 0
        rectMode(CORNER)
        if keyType[i] then
            fill(0)
            y=HEIGHT/4
            x = x - WIDTH/88/2*52/36
            --  rectMode(CENTER)
        end
        
        -- if i == current then
        --       fill(0, 202, 255, 255)
        --    end
        
        rect(x,y+HEIGHT/4,WIDTH/88*52/36,HEIGHT/2-y)
        
        x = x + WIDTH/88*52/36
        if keyType[i] then
            x = x - WIDTH/88/2*52/36
        end
        
    end
    
end

function drawKey2()
    stroke(0)
    strokeWidth(1.5)
    counter = 0
    for i=1,88 do
        fill(255)
        if i == current then
            fill(0, 202, 255, 255)
        end
        if keyType[i] == false then
            if touchEnabled and CurrentTouch.state == BEGAN then
                if i == 1 or i ==88 then
                    if i == 1 and CurrentTouch.x < WIDTH/52 then
                        playKey(1)
                        fill(186, 186, 186, 255)
                    elseif i == 88 and CurrentTouch.x > WIDTH-WIDTH/52 then
                        playKey(88)
                        fill(186, 186, 186, 255)
                    end
                else
                    if keyType[i+1] == false and keyType[i-1] == false then
                        if CurrentTouch.x > (counter)*WIDTH/52 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i-1] == false then
                        if CurrentTouch.x > (counter)*WIDTH/52 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4*3 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i+1] == false then
                        if CurrentTouch.x < (counter+1)*WIDTH/52 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x < (counter)*WIDTH/52+WIDTH/52/4 and CurrentTouch.x > (counter)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                    else
                        if CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4 then
                            if CurrentTouch.y < HEIGHT/2 then
                                playKey(i)
                                
                                fill(186, 186, 186, 255)
                            end
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4*3 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4*3 and CurrentTouch.x > (counter)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                        
                        
                    end
                end
                
            end
            rect((counter)*WIDTH/52,HEIGHT/4,WIDTH/52,HEIGHT/2)
            counter = counter + 1
        end
    end
    
    
    counter = 0
    for i=1,88 do
        fill(0)
        if i == current then
            fill(0, 202, 255, 255)
        end
        
        if keyType[i] == false then
            counter = counter + WIDTH/52
        end
        if keyType[i] then
            counter = counter - WIDTH/52/4
            if touchEnabled and CurrentTouch.state == BEGAN then
                if CurrentTouch.y > HEIGHT/4+HEIGHT/8 then
                    if CurrentTouch.x > counter and CurrentTouch.x < counter+WIDTH/52/2 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                    end
                end
            end
            rect(counter,HEIGHT/4+HEIGHT/8,WIDTH/52/2,HEIGHT/8*3)
            counter = counter +WIDTH/52/4
        end
        
    end
end


function drawKey3()
    stroke(0)
    strokeWidth(1.5)
    counter = 0
    yPush = 0
    xPush=0
    for i=1,88 do
        fill(255)
        if i == current then
            fill(0, 202, 255, 255)
        end
        if keyType[i] == false then
            if touchEnabled and CurrentTouch.state == BEGAN then
                if i == 1 or i ==88 then
                    if i == 1 and CurrentTouch.x < WIDTH/52*2 and CurrentTouch.y < HEIGHT/2 then
                        playKey(1)
                        fill(186, 186, 186, 255)
                    elseif i == 88 and CurrentTouch.x > WIDTH-WIDTH/52*2 and CurrentTouch.y > HEIGHT/2  then
                        playKey(88)
                        fill(186, 186, 186, 255)
                    end
                else
                    if keyType[i+1] == false and keyType[i-1] == false then
                        if CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i-1] == false then
                        if CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2*3 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                    elseif keyType[i+1] == false then
                        if CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.x < (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                    else
                        if CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            --   if CurrentTouch.y < HEIGHT/2 then
                            playKey(i)
                            
                            fill(186, 186, 186, 255)
                            --     end
                        elseif CurrentTouch.x > (counter+xPush)*WIDTH/52*2+WIDTH/52/4*3*2 and CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        elseif CurrentTouch.x < (counter+xPush+1)*WIDTH/52*2-WIDTH/52/4*3*2 and CurrentTouch.x > (counter+xPush)*WIDTH/52*2 and CurrentTouch.y>yPush+HEIGHT/6 and CurrentTouch.y < HEIGHT/2+yPush then
                            playKey(i)
                            fill(186, 186, 186, 255)
                        end
                        
                        
                        
                    end
                end
                
            end
            rect((counter+xPush)*WIDTH/52*2,HEIGHT/6+yPush,WIDTH/52*2,HEIGHT/3)
            if counter == 26 then
                yPush = yPush + HEIGHT/3
                xPush = xPush - 26
            end
            counter = counter + 1
        end
    end
    xPush=0
    yPush=0
    
    counter = 0
    for i=1,88 do
        fill(0)
        if i == current then
            fill(0, 202, 255, 255)
        end
        
        if keyType[i] == false then
            counter = counter + WIDTH/52*2
        end
        if keyType[i] then
            counter = counter - WIDTH/52/4*2
            if touchEnabled and CurrentTouch.state == BEGAN then
                if CurrentTouch.y > HEIGHT/6+HEIGHT/12+yPush and CurrentTouch.y <HEIGHT/2+yPush then
                    if CurrentTouch.x > counter and CurrentTouch.x < counter+WIDTH/52/2*2 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                    end
                end
            end
            rect(counter,HEIGHT/6+HEIGHT/12+yPush,WIDTH/52,HEIGHT/12*3)
            counter = counter +WIDTH/52/4*2
            if counter>= WIDTH then
                counter = 0
                yPush = yPush + HEIGHT/3
            end
        end
        
    end
end

function readKey()
    x = 0
    for i =1,88 do
        if CurrentTouch.x > x and CurrentTouch.x < x+WIDTH/90 then
            return i
        end
        x = x + WIDTH/90
    end
    return 1
end

function readKey2()
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(255, 255, 255, 255)
    drawKey2()
    --sprite("Project:piano",WIDTH/2,HEIGHT/2,WIDTH)
    if isBlink then
        playKey(current)
    end
    
  --  if CurrentTouch.state == BEGAN and touchEnabled then
   --     playKey(readKey())
   -- end
    -- This sets the line thickness
    strokeWidth(5)
    -- Do your drawing here
    
end

function playKey(key)
   -- print(key)
    sound("Dropbox:SingleKey",1.0,frequency[key]/261.626)
end

function drawKey()
    x=0
    stroke(0)
    strokeWidth(1.0)
    for i=1,#keyType do
    fill(255, 255, 255, 0)
        y = 0
     rectMode(CORNER)
    if keyType[i] then
            fill(0)
            y=HEIGHT/4
            x = x - WIDTH/88/2*52/36
          --  rectMode(CENTER)
        end
        
    -- if i == current then
     --       fill(0, 202, 255, 255)
    --    end
        
        rect(x,y+HEIGHT/4,WIDTH/88*52/36,HEIGHT/2-y)
        
        x = x + WIDTH/88*52/36
        if keyType[i] then
            x = x - WIDTH/88/2*52/36
        end
         
        end

end

function drawKey2()
    stroke(0)
    strokeWidth(1.5)
    counter = 0
    for i=1,88 do
        fill(255)
        if i == current then
            fill(0, 202, 255, 255)
        end
        if keyType[i] == false then
            if touchEnabled and CurrentTouch.state == BEGAN then
                if i == 1 or i ==88 then
                    if i == 1 and CurrentTouch.x < WIDTH/52 then
                        playKey(1)
                        fill(186, 186, 186, 255)
                        elseif i == 88 and CurrentTouch.x > WIDTH-WIDTH/52 then
                        playKey(88)
                        fill(186, 186, 186, 255)
                    end
                else
                if keyType[i+1] == false and keyType[i-1] == false then
                    if CurrentTouch.x > (counter)*WIDTH/52 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                        playKey(i)
                            fill(186, 186, 186, 255)
                            end
                    elseif keyType[i-1] == false then
                        if CurrentTouch.x > (counter)*WIDTH/52 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4*3 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                        playKey(i)
                            fill(186, 186, 186, 255)
                            end
                        elseif keyType[i+1] == false then
                             if CurrentTouch.x < (counter+1)*WIDTH/52 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x < (counter)*WIDTH/52+WIDTH/52/4 and CurrentTouch.x > (counter)*WIDTH/52 then
                        playKey(i)
                            fill(186, 186, 186, 255)
                            end
                        
                        else
                        if CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                        elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x > (counter)*WIDTH/52+WIDTH/52/4*3 and CurrentTouch.x < (counter+1)*WIDTH/52 then
                        playKey(i)
                            fill(186, 186, 186, 255)
                            elseif CurrentTouch.y < HEIGHT/2+HEIGHT/8 and CurrentTouch.x < (counter+1)*WIDTH/52-WIDTH/52/4*3 and CurrentTouch.x > (counter)*WIDTH/52 then
                            playKey(i)
                            fill(186, 186, 186, 255)
                            end
                        
                        
                        
                    end
                    end
                    
            end
        rect((counter)*WIDTH/52,HEIGHT/4,WIDTH/52,HEIGHT/2)
            counter = counter + 1
            end
    end
    
    
    counter = 0
    for i=1,88 do
        fill(0)
         if i == current then
            fill(0, 202, 255, 255)
        end
        
        if keyType[i] == false then
            counter = counter + WIDTH/52
        end
        if keyType[i] then
            counter = counter - WIDTH/52/4
            if touchEnabled and CurrentTouch.state == BEGAN then
                if CurrentTouch.y > HEIGHT/2+HEIGHT/8 then
                    if CurrentTouch.x > counter and CurrentTouch.x < counter+WIDTH/52/2 then
                        playKey(i)
                        fill(186, 186, 186, 255)
                    end
                end
            end
            rect(counter,HEIGHT/4+HEIGHT/8,WIDTH/52/2,HEIGHT/8*3)
            counter = counter +WIDTH/52/4
        end
        
    end
end

function readKey()
    x = 0
    for i =1,88 do
        if CurrentTouch.x > x and CurrentTouch.x < x+WIDTH/90 then
            return i
        end
        x = x + WIDTH/90
    end
    return 1
end

function readKey2()

end
