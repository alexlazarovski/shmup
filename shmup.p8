pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- todo
--------------------
-- game flow
-- music
-- multiple enemies
-- big enemies
-- enemy bullets

function _init()
 cls(0)
 mode="start"
 blinkt=1
 
 t=0
end

function _update()
 t+=1
 blinkt+=1

 
 if mode=="game" then
  update_game()
 elseif mode=="start" then
  update_start()
 elseif mode=="over" then
  update_over()
 end

end

function _draw()

 if mode=="game" then
  draw_game()
 elseif mode=="start" then
  --startdraw
  draw_start()
 elseif mode=="over" then
  draw_over()
 end
 
end

function startgame()
 mode="game"
 t=0
 
 ship={}
 ship.x=64
 ship.y=64
 ship.sx=0
 ship.sy=0
 ship.spr=2
 
 invul=0
 
 flamespr=5
 
 bultimer=0
 bullets={}
 muzzle=0
 
 score=0
 
 lives=4
 
 stars={}
 for i=1,100 do
  local newstar={}
  newstar.x=flr(rnd(128))
  newstar.y=flr(rnd(128))
  newstar.spd=rnd(1.5)+0.5
  add(stars,newstar)
 end
 
 enemies={}
 
 explods={}
 
 parts={}
 hitparts={}
 
 shwaves={}
 
 spawnen()
 
end






-->8
-- helpers
function drawstarfield()
 for i=1,#stars do
  local mystar=stars[i]
  local scolor=6
  
  if mystar.spd<1 then
   scolor=1
  elseif mystar.spd<1.5 then
   scolor=13
  end
  
  pset(mystar.x,mystar.y,scolor) 
 end
end

function animatestars()
 --animate background
	for i=1,#stars do
	 local mystar=stars[i]
	 mystar.y+=mystar.spd
	 if mystar.y>128 then
	  mystar.y-=128
	 end
	end
end

function drawbullet()
 for bullet in all(bullets) do
  drwmyspr(bullet)
 end
end

function drawbulletsmuzzle()
 if muzzle>0 then
  circfill(
   ship.x+3, ship.y-3,muzzle,7)
	end
end

function drawlives() 
 for i=1,4 do
  if lives>=i then
   spr(13,i*9-8,1)
  else
   spr(12,i*9-8,1)
  end
 end
end

function blink()
 local blinkanim={5,5,5,5,5,5,5,6,6,6,7,7,6,6,5,5}
	if blinkt>#blinkanim then
	 blinkt=1
	end 
 return blinkanim[blinkt]

end

function drwmyspr(myspr)
 spr(myspr.spr,myspr.x,myspr.y)
end

function col(a,b)
 
 local a_left=a.x
 local a_top=a.y
 local a_right=a.x+7
 local a_bottom=a.y+7
 
 local b_left=b.x
 local b_top=b.y
 local b_right=b.x+7
 local b_bottom=b.y+7
 
 if a_top>b_bottom then return false end
 if b_top>a_bottom then return false end
 if a_left>b_right then return false end
 if b_left>a_right then return false end
 
 
 return true
end

function spawnen()
 local myen={}
 myen.x=rnd(120)
 myen.y=-8
 myen.spr=21
 myen.hp=5
 myen.flash=0

 add(enemies,myen)
 
end

function enemyhit(expx, expy)
for i=1,5 do
	 local myp={}
	 myp.x=expx
	 myp.y=expy
	 myp.sx=(rnd()-0.5)*3
	 myp.sy=(rnd()-0.5)*3
	 
	 myp.age=rnd(2)
	 myp.maxage=7+rnd(5)
	 
	 add(hitparts,myp)
 end

end

function explode(expx, expy,isblue)
 --initial big explosion
 local myp={}
 myp.x=expx
	myp.y=expy
 myp.sx=0
 myp.sy=0
 
 myp.age=0
 myp.maxage=0
 myp.size=10
 myp.blue=isblue
 
 add(parts,myp)
 
 for i=1,30 do
	 local myp={}
	 myp.x=expx
	 myp.y=expy
	 myp.sx=(rnd()-0.5)*6
	 myp.sy=(rnd()-0.5)*6
	 
	 myp.age=rnd(2)
	 myp.maxage=10+rnd(10)
	 myp.size=1+rnd(4)
	 myp.blue=isblue
 
	 add(parts,myp)
 end

 for i=1,20 do
	 local myp={}
	 myp.x=expx
	 myp.y=expy
	 myp.sx=(rnd()-0.5)*10
	 myp.sy=(rnd()-0.5)*10
	 
	 myp.age=rnd(2)
	 myp.maxage=10+rnd(10)
	 myp.size=1+rnd(4)
	 myp.blue=isblue
 	myp.spark=true
	 
	 add(parts,myp)
 end
  
 big_shwave(expx, expy)
end

function page_red(page)
 local col=7
 if page>5 then
  col=10
 end
 if page>7 then
  colc=9
 end
 if page>10 then
  col=8
 end
 if page>12 then
  col=2
 end
 if page>15 then
  col=5
 end
 return col
end

function page_blue(page)
 local col=7
 if page>5 then
  col=6
 end
 if page>7 then
  colc=12
 end
 if page>10 then
  col=13
 end
 if page>12 then
  col=1
 end
 if page>15 then
  col=1
 end
 return col
end

function page_green(page)
 local col=11
  if page>2 then
   pc=11
  end
  if page>4 then
   pc=3
  end
  if page>8 then
   pc=2
  end
  if page>10 then
   pc=1
  end
 return col
end

function smal_shwave(shx,shy)
 local mysw={}
 mysw.x=shx
 mysw.y=shy
 mysw.r=3
 mysw.tr=6
 mysw.col=9
 mysw.speed=1
 add(shwaves,mysw)
end

function big_shwave(shx,shy)
 local mysw={}
 mysw.x=shx
 mysw.y=shy
 mysw.r=3
 mysw.tr=25
 mysw.col=7
 mysw.speed=3.5
 add(shwaves,mysw)
end

function smal_spark(sx,sy)
 --for i=1,2 do
	 local myp={}
	 myp.x=sx
	 myp.y=sy
	 myp.sx=(rnd()-0.5)*8
	 myp.sy=(rnd()-1)*3
	 
	 myp.age=rnd(2)
	 myp.maxage=10+rnd(10)
	 myp.size=1+rnd(4)
	 myp.blue=isblue
 	myp.spark=true
	 
	 add(parts,myp)
 --end
end
-->8
-- update

function update_game()
 --controls
 ship.sx=0
 ship.sy=0
 ship.spr=2
 
 
 if (btn(0)) then  
  ship.sx = -2
	 ship.spr=1
	end
	if btn(1) then 
	 ship.sx = 2
	 ship.spr=3 
	end
	if btn(2) then 
	 ship.sy = -2 
	end
	if btn(3) then 
	 ship.sy = 2 
	end
	
	if btn(5) then
	 if bultimer<=0 then
	  local bullet={}
	  bullet.x=ship.x
	  bullet.y=ship.y-4
	  bullet.spr=16
	  add(bullets, bullet)
	  sfx(0)
	  muzzle=6
	  bultimer=5
	 end
	end
	bultimer-=1
	
	--moving the ship
	ship.x+=ship.sx
	ship.y+=ship.sy
	
	--move the bullet
	for bullet in all(bullets) do
	 bullet.y-=4
	 
	 if bullet.y<-8 then
	  del(bullets,bullet)
	 end 
	end
	
	
	--moving enemies
	for myen in all(enemies) do
	 myen.y+=1
	 
	 --enemy animation
	 myen.spr+=0.4
	 if myen.spr>=25 then
	  myen.spr=21
	 end 
	 
	 if(myen.y>128) then
	  del(enemies,myen)
	  spawnen()
	 end
	end
	
	--collission bullet x enemies
	for bullet in all(bullets) do
	 for myen in all(enemies) do
	  if col(bullet, myen) then
	   del(bullets, bullet)
	   smal_shwave(bullet.x+4, bullet.y+4)
	   myen.hp-=1
	   sfx(3)
	   myen.flash=2
	   --enemyhit(myen.x+4,myen.y+4)
	   smal_spark(myen.x+4,myen.y+4)
	   if myen.hp<=0 then
	    del(enemies, myen)
 	   sfx(2)
	    score+=1
	    spawnen()
	    explode(myen.x+4,myen.y+4)
	   end
	  end
	 end
	end
	
	--collishion ship x enemies
	if invul<=0 then
		for myen in all(enemies) do
		 if col(myen, ship) then
		  explode(ship.x+4,ship.y+4,true)
		  lives-=1
		  sfx(1)
		  isinv=true
		  invul=60
		 end
		end
	else
	 invul-=1
	end
	
		
	if lives<=0 then
	 mode="over"
	end
	
	--animate flame
	flamespr=flamespr+1
	if flamespr>9 then
	 flamespr=5
	end
	
	--animate muzzle flash
	if muzzle>0 then
	 muzzle = muzzle-1
	end
	
	if ship.x>120 then
		ship.x=120
	end
	
	if ship.x<0 then 
	 ship.x=0
	end
	
	if ship.y<0 then
	 ship.y=0
	end
	
	if ship.y>120 then
	 ship.y=120
	end
	
	animatestars()

end

function update_start()

 if btnp(4) or btnp(5) then
  startgame()
 end
 
end

function update_over()
 if btnp(4) or btnp(5) then
  mode="start"
 end
end
-->8
-- draw

function draw_game()
 cls(0)
 
 --this draws the background
 drawstarfield()

	-- this draws the ship
	if invul<=0 then
	 drwmyspr(ship)
	 spr(flamespr,ship.x,ship.y+8)
 else
  --invul state
  if sin(t/5)<0.2 then
   drwmyspr(ship)
   spr(flamespr,ship.x,ship.y+8)
  end
 end
 
 --draw enemies
 for enemy in all(enemies) do
  if enemy.flash >0 then
   enemy.flash-=1
   for i=1,15 do
    pal(i,7)
   end
  end
  drwmyspr(enemy)
  pal()
 end
 
 drawbullet()
 
 drawbulletsmuzzle()
 
 --drawing hit effects
 for myp in all(hitparts) do
  local pc=page_green(myp.age)
  
  pset(myp.x,myp.y,pc)
 	myp.x+=myp.sx
  myp.y+=myp.sy
  
  myp.sx=myp.sx*0.7
  myp.sy=myp.sy*0.7
  
  myp.age+=1
  if myp.age>myp.maxage then
   del(hitparts,myp)
  end
 end
 
 --drawing shwaves
 for mysw in all(shwaves) do
  circ(mysw.x, mysw.y,mysw.r,mysw.col)
  mysw.r+=mysw.speed
  if mysw.r>mysw.tr then
   del(shwaves,mysw)
  end
 end
	
 --drawing particles
 for myp in all(parts) do
  local pc
  if myp.blue then
   pc=page_blue(myp.age)
  else
   pc=page_red(myp.age)
  end
  
  if myp.spark then
   pset(myp.x,myp.y,7)
  else
   circfill(myp.x,myp.y,myp.size,pc)
  end
  myp.x+=myp.sx
  myp.y+=myp.sy
  
  myp.sx=myp.sx*0.85
  myp.sy=myp.sy*0.85
  
  myp.age+=1
  if myp.age>myp.maxage then
   myp.size-=0.5
   if myp.size<0 then
    del(parts,myp)
   end
  end
 end
 
	
	--draw score
	print("score:"..score,40,1,12)
 drawlives()
 
end

function draw_start()
 cls(1)
 print("awesome shmup",34,40,12)
 print("press any key to start",20,80,blink())
end

function draw_over()
 cls(8)
 print("game over",45,40,2)
 print("press any key to continue",15,80,blink())
end
__gfx__
00000000000220000002200000022000000000000000000000000000000000000000000000000000000000000000000008800880088008e00000000000000000
000000000028820000288200002882000000000000077000000770000007700000c77c00000770000000000000000000800880088788888e0000000000000000
007007000028820000288200002882000000000000c77c000007700000c77c000cccccc000c77c00000000000000000080000008878888880000000000000000
0007700000288e2002e88e2002e882000000000000cccc00000cc00000cccc0000cccc0000cccc00000000000000000080000008888888880000000000000000
00077000027c88202e87c8e202887c2000000000000cc000000cc000000cc00000000000000cc000000000000000000008000080028888800000000000000000
007007000211882028811882028811200000000000000000000cc000000000000000000000000000000000000000000000800800002888000000000000000000
00000000025582200285582002285520000000000000000000000000000000000000000000000000000000000000000000088000000280000000000000000000
00000000002aa200002aa200002aa200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000330033003300330033003300330033000000000000000000000000000000000000000000000000000000000
09aaaa900000000000000000000000000000000033b33b3333b33b3333b33b3333b33b3300000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000003bbbbbb33bbbbbb33bbbbbb33bbbbbb300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000003b7717b33b7717b33b7717b33b7717b300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000b7117b00b7117b00b7117b00b7117b000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000037730000377300003773000037730000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000303303003033030030330300303303000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000300003030000003030000300330033000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000990000000000000505005000000000050005000000000000000000000000000000000000000000000000000000000000000000000
00000000070000000009999999900000005055555050505000500055505000500000005050000000000000000000000000000000000000000000000000000000
007000000000007000999aaaaa999000050552222222550005055052250255000000000000005000000000000000000000000000000000000000000000000000
0007700aaa9000000099aa777aa99000005228888882250000550552228825000000000500550050000000000000000000000000000000000000000000000000
00000777777a0000099aa77777aaa900052288899998225005222222522855500005005005555000000000000000000000000000000000000000000000000000
000077777777070009aa777777aaa9000528899aaa99825005288295599582200055005000000050000000000000000000000000000000000000000000000000
000a77777777a00099a77777777aa990552899aa7aa9825555589955999882550055505000055005000000000000000000000000000000000000000000000000
000a77777777a0009aa777777777a9905528aaa777aa825555525555988822550000000000055005000000000000000000000000000000000000000000000000
000a77777777a0009aa777777777a99005289aa77aa9825005598555988858500055500000550050000000000000000000000000000000000000000000000000
000aa7777777000099aa77777777a990002889aaaaa9820000258895988855000055500500550000000000000000000000000000000000000000000000000000
0000977777aa000009aa7777777aa9000522889a9999825005225585959985500000000005000050000000000000000000000000000000000000000000000000
07700777aaa00700099aaa7777aaa900055528999888825005552585222882550050005550000050000000000000000000000000000000000000000000000000
000700000000000000999aaaaaa99900005052288882250000502255228555000000555055000000000000000000000000000000000000000000000000000000
000000700700000000009999a9999000000550222222050005055552250205000000555000050000000000000000000000000000000000000000000000000000
00000000070000000000009999900000000005055550000000005505555000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000500000000000000505000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003755035550325502f5502c550295502555022550205501e5501c5501a550175501555012550105500e5500c5500a550075500755006550045500355000550100000d0000a0000800005000020000b000
000100002c6502b6502b650336502e650276501a65015640126300f6200d620086200662005620046100461003610036100360004600056000460003600000000000000000000000000000000000000000000000
0001000036750066502c5502163010620095200662004620056100465006610006000660001600006200a6000a600026300260026600026200860016300006200760026500026000000000000000000000000000
000100000d6102a620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005000037250362503a3502745027450264502345036350214501e4501b45022350184501d35016450193501445019350124501c350114502435010450104500f4500f450250502c05033050380500000000000
