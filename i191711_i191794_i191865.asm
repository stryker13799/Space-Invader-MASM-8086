.model large
.stack 4096

;structures
BulletStruct STRUCT
   flag dw ? ;display bullet or not
   x dw ? ;x coord
   y dw ? ;y coord
BulletStruct ENDS 

EnemyStruct STRUCT
   flag dw ?
   num dw ? ;stores what type of enemy to draw
   x dw ? ;x coord
   y dw ? ;y coord
EnemyStruct ENDS 

HeartStruct STRUCT
	flag dw ? ;display heart or not
	x dw ? ;x coord
	y dw ? ;y coord
HeartStruct ENDS


.data

menu        db "    ", 13, 10
            db "    ", 13, 10
            db "    ", 13, 10
            db "    ENTER YOUR CHOICE OF LEVEL!", 13, 10
            db "    ", 13, 10
            db "      	 1. LEVEL 1", 13, 10
			db "    ", 13, 10
            db "      	 2. LEVEL 2", 13, 10
			db "    ", 13, 10
            db "       	 3. LEVEL 3", 13, 10
			db "    ", 13, 10
			db "       	 4. SCOREBOARD", 13, 10
			db "    ", 13, 10
			db "       	 ESC. EXIT GAME", 13, 10
			
            db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
            db "    ", 13, 10, '$'
menu_flag dw 0


score word 0
score_string db "SCORE: $"

FNAME db "name.txt", 0
FNAME1 db "score.txt", 0


fsaver db 500 DUP('$')

FHANDLE dw 0
FHANDLE1 dw 0
rhandle dw 0
rhandle1 dw 0
bullet_limit dw 4
bullet_count dw 0
enemy_limit dw 10
enemy_count dw 10

;declaring structs
bullet BulletStruct 4 DUP (<0,0,0>)
enemy EnemyStruct 10 DUP (<1,0,0,0>)
heart HeartStruct 3 DUP(<1,300,580>)

SizeOfBullet EQU 6
SizeOfEnemy EQU 8
SizeOfHeart EQU 6

;SCREEN LIMITS
screen_limit_x dw 640
screen_limit_y dw 480



temper      db "    ", 13, 10
            db "    ", 13, 10
            db "    ", 13, 10
			db "     HIGH SCORE : 9", 13, 10
            db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
			db "    ", 13, 10
            db "    ", 13, 10, '$'



;-------SCREEN MODE-------------
_welcome byte "Galaxy Attack: Alien Shooter"
_enter byte "ENTER YOUR NAME UPTO 8 LETTERS"
_name byte 8 DUP('$')
_over byte "GAME OVER"
_again byte "Press ESC to Start Again"
_quit byte "Press ENTER to Quit"
_level byte "Level:"
_score byte "Score:"
_cursor byte 6

row_no dw ?
col_no dw ?

;player size
player_dim_x dw 16
player_dim_y dw 16
player_jump_flag dw 0 ; is player jumping

;enemy size
enemy_dim_x dw 32
enemy_dim_y dw 32

;special enemy
enemy_special_dim_x dw 18
enemy_special_dim_y dw 18
enemy_special_flag dw 0
enemy_special_y dw 0
enemy_special_x dw 0

;monster enemy
enemy_monster_dim_x dw 60
enemy_monster_dim_y dw 36
enemy_monster_flag dw 0
enemy_monster_y dw 0
enemy_monster_x dw 0
enemy_monster_bullet_flag dw 0
enemy_monster_bullet_x dw 0
enemy_monster_bullet_y dw 0

;bullet size
bullet_dim_x dw 8
bullet_dim_y dw 8 

;explosion size
explosion_dim_x dw 16
explosion_dim_y dw 13

;heart
heart_dim_x dw 16
heart_dim_y dw 16
heart_count dw 3


;----------BACKGROUND---------
dx_back word  0
dy_back word 20

;random number
rand_num db 0 ;RANDOM NUMBER IS BYTE
rand_num_binary db 0

;counter
counter dw 0
counter_two dw 0
counter_jump dw 0
temp db 0


;Space Ship bitmap array
SpaceShip   db   0,   0,   0,   0,   0,   0,   0,  15,  15,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,  15,  15,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,  15,  15,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,  15,  15,  15,  15,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,  15,  15,  15,  15,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,  40,   0,   0,  15,  15,  15,  15,   0,   0,  40,   0,   0,   0
			db   0,   0,   0,  40,   0,   0,  15,  15,  15,  15,   0,   0,  40,   0,   0,   0
			db   0,   0,   0,  15,   0,  15,  15,  15,  15,  15,  15,   0,  15,   0,   0,   0
			db  40,   0,   0,  15,  54,  15,  15,  40,  40,  15,  15,  54,  15,   0,   0,  40
			db  40,   0,   0,  54,  15,  15,  40,  40,  40,  40,  15,  15,  54,   0,   0,  40
			db  15,   0,   0,  15,  15,  15,  40,  15,  15,  40,  15,  15,  15,   0,   0,  15
			db  15,   0,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,  15,   0,  15
			db  15,  15,  15,  15,  15,  40,  15,  15,  15,  15,  40,  15,  15,  15,  15,  15
			db  15,  15,  15,   0,  40,  40,  15,  15,  15,  15,  40,  40,   0,  15,  15,  15
			db  15,  15,   0,   0,  40,  40,   0,  15,  15,   0,  40,  40,   0,   0,  15,  15
			db  15,   0,   0,   0,   0,   0,   0,  15,  15,   0,   0,   0,   0,   0,   0,  15

SpaceShipJump   db  15,  15,  15,  15,  15,  15,  40,  40,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,  15,  15,  15,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,   0,  15,  15,  15,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,   0,   0,  15,  15,  15,  54,  15,  15,  40,  40,   0,   0,   0,   0,   0
				db   0,  40,  40,  15,  15,  15,  15,  54,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,  40,  40,  40,  15,  15,  15,  15,  15,   0,   0,   0,   0,   0,   0,   0
				db   0,   0,  15,  15,  15,  40,  40,  15,  15,  15,  15,  15,  15,   0,   0,   0
				db  15,  15,  15,  15,  15,  15,  40,  40,  15,  15,  15,  15,  15,  15,  15,  15
				db  15,  15,  15,  15,  15,  15,  40,  40,  15,  15,  15,  15,  15,  15,  15,  15
				db   0,   0,  15,  15,  15,  40,  40,  15,  15,  15,  15,  15,  15,   0,   0,   0
				db   0,  40,  40,  40,  15,  15,  15,  15,  15,   0,   0,   0,   0,   0,   0,   0
				db   0,  40,  40,  15,  15,  15,  15,  54,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,   0,   0,  15,  15,  15,  54,  15,  15,  40,  40,   0,   0,   0,   0,   0
				db   0,   0,  15,  15,  15,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,  15,  15,  15,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				db  15,  15,  15,  15,  15,  15,  40,  40,   0,   0,   0,   0,   0,   0,   0,   0

;enemy of type 1
EnemyOne    db   0,   0,   0,   0,   0,   0,   0,   0,   0, 226, 226, 226, 226, 226, 226,   0,   0, 226, 226, 226, 226, 226, 226,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0, 166, 164, 173, 204, 207, 207, 226, 226, 226, 226, 207, 207, 204, 173, 164, 166,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0, 226, 226, 226, 226, 166, 166, 166, 166, 167, 166, 226, 226, 226, 226, 166, 167, 166, 166, 166, 166, 226, 226, 226, 226,   0,   0,   0,   0
			db   0,   0,   0,   0, 226, 226, 226, 226, 151, 131, 131, 131, 130, 226, 226, 226, 226, 226, 226, 130, 131, 131, 131, 151, 226, 226, 226, 226,   0,   0,   0,   0
			db   0,   0,   0,   0, 220, 220, 220, 218,   0,  81, 100, 100,  89, 154, 218, 220, 220, 218, 154,  89, 100, 100,  81,   0, 218, 220, 220, 220,   0,   0,   0,   0
			db   0,   0,   0,   0, 175, 175, 175, 166,   0,   5,  13,  14,   6,  37, 165, 176, 176, 165,  37,   6,  14,  13,   5,   0, 166, 175, 175, 175,   0,   0,   0,   0
			db   0,   0,   0,   0, 150, 150, 150, 141,   0,  13,  43,  44,  22,  27, 140, 150, 150, 140,  27,  22,  44,  43,  13,   0, 141, 150, 150, 150,   0,   0,   0,   0
			db   0,   0,   0,   0, 114, 114, 114, 107,   0,  45, 147, 153,  80,  19, 106, 114, 114, 106,  19,  80, 153, 147,  45,   0, 107, 114, 114, 114,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  29,  46,   9,   0,  46, 151, 163, 128,  76,  52,  50,  50,  52,  76, 128, 163, 151,  46,   0,   9,  46,  29,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   5,  10,   1,   0,  46, 151, 169, 167, 130,  21,  10,  10,  21, 130, 167, 169, 151,  46,   0,   1,  10,   5,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  57, 112,  14,   0,  46, 151, 169, 172, 162, 131, 128, 128, 131, 162, 172, 169, 151,  46,   0,  14, 112,  57,   0,   0,   0,   0,   0
			db   0,  23,  41,  38,   6,  69, 135,  17,   0,  46, 151, 164, 171, 169, 156, 154, 154, 156, 169, 171, 164, 151,  46,   0,  17, 135,  69,   6,  38,  41,  23,   0
			db   0,  86, 152, 141,  30,  67, 134,  17,   0,  47, 151, 153, 162, 170, 154, 153, 153, 154, 170, 162, 153, 151,  47,   0,  17, 134,  67,  30, 141, 152,  86,   0
			db   0,  89, 157, 146,  31,  67, 134,  17,   0,  46, 151, 161, 164, 161, 153, 153, 153, 153, 161, 164, 161, 151,  46,   0,  17, 134,  67,  31, 146, 157,  89,   0
			db   0,  85, 150, 140,  30,  67, 134,  17,   0,  46, 151, 169, 161, 148, 152, 153, 153, 152, 148, 161, 169, 151,  46,   0,  17, 134,  67,  30, 140, 150,  85,   0
			db   0,  21,  37,  34,   5,  68, 134,  17,   0,  46, 151, 161, 102,  57, 145, 153, 153, 145,  57, 102, 161, 151,  46,   0,  17, 134,  68,   5,  34,  37,  21,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,  47, 148, 126,  61,  27, 143, 154, 154, 143,  27,  61, 126, 148,  47,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,  48, 144,  37,   0,  29, 143, 154, 154, 143,  29,   0,  37, 144,  48,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,  37,  76,  27,   0,  28, 143, 154, 154, 143,  28,   0,  27,  76,  37,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,   0,   0,   0,   0,  29, 142, 153, 153, 142,  29,   0,   0,   0,   0,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,   0,   0,   0,   0,  27, 140, 151, 151, 140,  27,   0,   0,   0,   0,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,   0,   0,   0,   0,  27, 139, 150, 150, 139,  27,   0,   0,   0,   0,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,   0,   0,   0,   0,  29, 145, 155, 155, 145,  29,   0,   0,   0,   0,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  68, 134,  17,   0,   0,   0,   0,   0,  24,  80,  84,  84,  80,  24,   0,   0,   0,   0,   0,  17, 134,  68,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  67, 132,  17,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  17, 132,  67,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,  33,  43,  13,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  13,  43,  33,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0

;enemy of type 2
EnemyTwo    db   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,  48,  48,  48,  48,   0,   0,  48,  48,  48,  48,  48,  48,   0,   0,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,  48,  48,  48,  48,   0,   0,  48,  48,  48,  48,  48,  48,   0,   0,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db  48,  48,   0,   0,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db  48,  48,   0,   0,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,  48,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db  48,  48,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db  48,  48,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  48,  48,   0,   0,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,  48,  48,  48,  48,   0,   0,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,  48,  48,  48,  48,   0,   0,  48,  48,  48,  48,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
			db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0

;special enemy
EnemySpecial    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0                  
				db 0,0,0,0,0,0,0,6h,6h,6h,6h,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,6h,6h,6h,6h,6h,6h,0,0,0,0,0,0
				db 0,0,0,0,0,6h,6h,6h,6h,6h,6h,6h,6h,0,0,0,0,0
				db 0,0,0,0,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,0,0,0,0
				db 0,0,0,6h,0h,0h,6h,6h,6h,6h,6h,6h,0h,0h,6h,0,0,0
				db 0,0,6h,6h,6h,15,0h,6h,6h,6h,6h,0h,15,6h,6h,6h,0,0
				db 0,0,6h,6h,6h,15,0h,0h,0h,0h,0h,0h,15,6h,6h,6h,0,0
				db 0,6h,6h,6h,6h,15,0h,15,6h,6h,15,0h,15,6h,6h,6h,6h,0
				db 0,6h,6h,6h,6h,15,15,15,6h,6h,15,15,15,6h,6h,6h,6h,0
				db 0,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,6h,0
				db 0,0,6h,6h,6h,6h,15,15,15,15,15,15,6h,6h,6h,6h,0,0
				db 0,0,0,0,0,15,15,15,15,15,15,15,15,0,0,0,0,0
				db 0,0,0,0h,0h,15,15,15,15,15,15,15,15,0h,0h,0,0,0
				db 0,0,0h,0h,0h,0h,0h,15,15,15,15,0h,0h,0h,0h,0h,0,0
				db 0,0,0h,0h,0h,0h,0h,0h,0,0,0h,0h,0h,0h,0h,0h,0,0
				db 0,0,0,0h,0h,0h,0h,0h,0,0,0h,0h,0h,0h,0h,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;monster enemy
EnemyMonster   db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,18,44,44,44,18,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,18,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,18,18,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,18,18,44,44,44,18,18,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,18,18,44,44,44,44,18,18,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,18,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,18,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,18,0,0,0,0,0,0,0,0,0,0,0,18,18,0,0
				db 0,18,18,18,18,0,0,0,0,0,0,0,0,0,0,0,0,0,18,44,44,18,0,0,0,0,0,0,0,0,0,18,18,18,18,0,0
				db 0,18,18,18,18,18,0,0,0,0,0,0,0,0,0,0,0,0,18,44,18,0,0,0,0,0,0,0,0,0,18,18,18,18,18,0,0
				db 0,18,18,18,18,18,18,0,0,0,0,0,0,0,18,18,18,18,18,18,18,18,0,0,0,0,0,0,0,18,18,18,18,18,18,0,0
				db 0,18,18,18,18,44,44,18,0,0,0,0,18,18,44,44,44,44,44,44,44,44,18,18,0,0,0,0,18,44,44,18,18,18,18,0,0
				db 0,0,18,18,18,44,44,44,18,0,18,18,44,44,44,44,44,44,44,44,44,44,44,44,18,18,0,18,44,44,44,18,18,18,0,0,0
				db 0,0,0,18,44,44,44,44,44,18,44,44,44,44,44,18,18,18,18,18,18,18,18,44,44,44,18,44,44,44,44,44,18,0,0,0,0
				db 0,0,0,18,44,44,44,44,44,18,44,18,18,18,18,44,44,44,44,44,44,44,44,18,18,18,18,44,44,44,44,44,18,0,0,0,0
				db 0,0,0,18,44,44,44,44,44,44,18,18,44,44,44,44,44,44,44,44,44,44,44,44,18,18,44,44,44,44,44,44,18,0,0,0,0
				db 0,0,0,0,18,44,44,44,44,18,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,18,0,0,0,0,0
				db 0,0,0,0,18,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,18,0,0,0,0,0
				db 0,0,0,0,0,18,44,18,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,18,0,0,0,0,0,0
				db 0,0,0,0,0,18,44,18,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,18,0,0,0,0,0,0
				db 0,0,0,0,18,44,18,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,18,0,0,0,0,0
				db 0,0,0,0,18,44,18,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,18,0,0,0,0,0
				db 0,0,0,18,18,18,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,18,18,18,0,0,0,0
				db 0,0,18,18,44,18,44,44,44,44,00,00,44,44,44,44,44,44,44,44,44,44,44,44,00,00,44,44,44,44,18,44,18,18,0,0,0
				db 0,18,44,18,44,18,44,44,44,00,15,00,00,44,44,44,44,44,44,44,44,44,44,00,00,15,00,44,44,44,18,44,18,44,18,0,0
				db 0,18,44,18,18,18,44,44,44,00,00,00,00,44,44,44,44,44,44,44,44,44,44,00,00,00,00,44,44,44,18,18,18,44,18,0,0
				db 0,0,18,44,18,44,44,44,44,44,00,00,44,44,44,44,44,44,44,44,44,44,44,44,00,00,44,44,44,44,44,18,44,18,0,0,0
				db 0,0,18,18,18,44,44,40,40,44,44,44,44,44,44,44,44,00,00,44,44,44,44,44,44,44,44,40,40,44,44,18,18,18,0,0,0
				db 0,0,0,18,18,44,40,40,40,40,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,40,40,40,40,44,18,18,0,0,0,0
				db 0,0,0,0,0,18,40,40,40,40,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,40,40,40,40,18,0,0,0,0,0,0
				db 0,0,0,0,0,18,44,40,40,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,40,40,44,18,0,0,0,0,0,0
				db 0,0,0,0,0,0,18,44,44,44,44,44,44,44,00,44,44,00,00,44,44,00,44,44,44,44,44,44,44,18,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,18,18,18,44,44,44,44,44,44,00,00,44,44,00,00,44,44,44,44,44,44,18,18,18,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,18,18,18,44,44,44,44,44,44,44,44,44,44,44,44,18,18,18,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,18,44,18,18,44,44,44,44,44,44,44,44,18,18,44,18,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,18,44,44,44,18,18,18,18,18,18,18,18,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,18,44,44,44,44,44,18,40,44,44,44,44,44,18,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,18,18,44,44,44,40,44,44,18,44,44,44,18,18,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,18,44,18,44,41,41,40,18,44,18,44,18,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,18,18,18,41,42,41,40,18,18,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,41,41,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,43,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,0,43,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,0,43,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,0,43,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,42,0,43,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,41,43,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,42,41,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


;heart array
HeartArray      db   0,   0,  40,  40,  40,   0,   0,   0,   0,   0,  40,  40,  40,   0,   0,   0
				db   0,  40,  40,  40,  40,  40,   0,   0,   0,  40,  40,  40,  40,  40,   0,   0
				db  40,  40,  40,  40,  40,  40,  40,   0,  40,  40,  40,  40,  40,  40,  40,   0
				db  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,   0
				db  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,   0
				db  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,   0
				db   0,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,   0,   0
				db   0,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,   0,   0
				db   0,   0,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,  40,   0,   0,   0
				db   0,   0,   0,  40,  40,  40,  40,  40,  40,  40,  40,  40,   0,   0,   0,   0
				db   0,   0,   0,   0,  40,  40,  40,  40,  40,  40,  40,   0,   0,   0,   0,   0
				db   0,   0,   0,   0,   0,  40,  40,  40,  40,  40,   0,   0,   0,   0,   0,   0
				db   0,   0,   0,   0,   0,   0,  40,  40,  40,   0,   0,   0,   0,   0,   0,   0
				db   0,   0,   0,   0,   0,   0,   0,  40,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0


;Explosion Array
ExplosionArray  db  96,  78,  96,  81,  82,  76,  76, 128,  96,  90,  94,  96,  96,  96,  96,  96
				db  77,  96,  84,  77,  77, 138, 163,  76, 132,  81,  84,  93, 106,  96,  96,  96
				db  96,  81,  78,  88, 114, 181, 189, 197, 111, 110, 112,  76,  76,  96,  96,  96
				db  96,  96,  86,  82, 205, 202, 196, 205, 193, 186, 190, 148,  98,  99,  96,  93
				db  76, 128, 125, 159, 205, 203, 221, 231, 236, 221, 209, 138, 128, 139,  96, 141
				db  96, 119, 154, 177, 216, 218, 233, 245, 250, 241, 190, 139, 153, 135, 232,  96
				db  96, 126, 108, 117, 214, 209, 241, 255, 255, 237, 226, 167,  99, 150, 155,  77
				db  86,  96, 144, 105, 182, 210, 227, 236, 233, 242, 174,  94, 135, 141, 119,  82
				db  96,  76,  76, 106, 122, 178, 206, 225, 221, 225, 185, 145, 156, 157,  77, 104
				db  96,  99,  76, 145, 143, 130, 159, 160, 169, 156, 159, 107,  79, 141, 235,  96
				db  78,  96,  86,  78,  94, 140,  77, 106, 137, 147,  83,  77, 234, 184,  96, 155
				db  96,  96,  96,  96,  96, 160,  98,  77,  77,  77, 233, 150,  76,  96, 132,  96
				db  96,  96,  96,  90,  96, 191,  96,  98, 131, 109,  80,  78, 124,  96,  96,  96


;bullet array
BulletAray  DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
			DB 00h,00h,00h,04h,04h,00h,00h,00h     ;  1
			DB 00h,00h,00h,04h,04h,00h,00h,00h     ;  2
			DB 00h,00h,00h,04h,04h,00h,00h,00h     ;  3
			DB 00h,00h,00h,04h,04h,00h,00h,00h     ;  4
			DB 00h,00h,00h,04h,04h,00h,00h,00h     ;  5
			DB 00h,00h,00h,04h,04h,00h,00h,00h     ;  6
			DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  7

;monster's bullet array
MonsterBulletAray   DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  0
					DB 00h,00h,00h,01h,01h,00h,00h,00h     ;  1
					DB 00h,00h,00h,01h,01h,00h,00h,00h     ;  2
					DB 00h,00h,00h,01h,01h,00h,00h,00h     ;  3
					DB 00h,00h,00h,01h,01h,00h,00h,00h     ;  4
					DB 00h,00h,00h,01h,01h,00h,00h,00h     ;  5
					DB 00h,00h,00h,01h,01h,00h,00h,00h     ;  6
					DB 00h,00h,00h,00h,00h,00h,00h,00h     ;  7




;--------------------------- Level 1 variables --------------------------------------

sprite_y dw 580
sprite_x dw 650
move_x dw 650
;---------------------------------------------------------------------------------



;Macros
drawPixel MACRO row, col, color
	MOV AH, 0Ch
	MOV AL, Color
	MOV CX, col
	MOV DX, row			
	INT 10H
endm
   
drawObject MACRO ycoord, xcoord, leny, lenx, array
	push ax
	mov ax, ycoord 
	mov row_no, ax
	pop ax
	mov cx, leny 
	mov si, 0

	.REPEAT
		push cx
		mov cx, lenx
		push ax
		mov ax, xcoord
		mov col_no, ax
		pop ax
		mov bx, 0
		.REPEAT
			push cx
			cmp array[si+ bx],0
			drawPixel row_no, col_no, array[si+ bx]
			inc col_no
			inc bx
			pop cx
			dec cx
		.UNTIL (cx==0)
		add si, lenx
		inc row_no
		pop cx
		dec cx
	.UNTIL (cx==0)
endm

;Wrapper Macro for drawing player
drawPlayer MACRO ycoord,xcoord
	.IF player_jump_flag==0
		DrawObject ycoord,xcoord,player_dim_x,player_dim_y,SpaceShip
	.ELSE
		DrawObject ycoord,xcoord,player_dim_x,player_dim_y,SpaceShipJump
	.ENDIF
endm

;Wrapper Macro for drawing enemies
drawEnemy MACRO ycoord,xcoord,enemyType
	DrawObject ycoord,xcoord,enemy_dim_x,enemy_dim_y,enemyType
endm

;Wrapper Macro for drawing special enemies
drawEnemySpecial MACRO ycoord,xcoord
	DrawObject ycoord,xcoord,enemy_special_dim_x,enemy_special_dim_y,EnemySpecial
endm

;Wrapper Macro for drawing explosion
drawEnemyMonster MACRO ycoord,xcoord
	DrawObject ycoord,xcoord,enemy_monster_dim_x,enemy_monster_dim_y,EnemyMonster
endm

;Wrapper Macro for drawing bullet
drawBullet MACRO ycoord,xcoord
	DrawObject ycoord,xcoord,bullet_dim_x,bullet_dim_y,BulletAray
endm

;Wrapper Macro for drawing monster bullet
drawBulletMonster MACRO ycoord,xcoord
	DrawObject ycoord,xcoord,bullet_dim_x,bullet_dim_y,MonsterBulletAray
endm

;Wrapper Macro for drawing explosion
drawExplosion MACRO ycoord,xcoord
	DrawObject ycoord,xcoord,explosion_dim_x,explosion_dim_y,ExplosionArray
endm

;Wrapper Macro for drawing heart
drawHeart MACRO ycoord,xcoord
	DrawObject ycoord,xcoord,heart_dim_x,heart_dim_y,HeartArray
endm



;   Reference Color Modes
;   AL, 00 Black Color
;   AL, 01 Blue Color
;   AL, 02 Green Color
;   AL, 03 LightBlue Color
;   AL, 04 Red Color
;   AL, 05 Purple Color
;   AL, 06 Brown Color
;   AL, 07 Grey Color
;   AL, 08 DarkGrey Color
;   AL, 09 Violet Color
;   AL, 10 YellowGreen Color
;   AL, 11 WhiteBlue Color
;   AL, 12 WhitishPink Color
;   AL, 13 WhiteishPurple Color
;   AL, 14 WhiteYellow Color
;   AL, 15 White Color
.code
;----------------------------MAIN----------------------------------------
Main proc
    mov ax,@data
    mov ds,ax


	mov ah, 0h ; Seting Video mode 
	mov al, 13h ; 640 x 480- x 16 VGA
	int 10h


	; Background color
	mov ah, 06h 
	mov al, 0
	mov bh, 0
	mov bl, 0
	mov cx,0
	mov dh,50
	mov dl,50
	int 10h
; ----------------

	call namereader
	call ClearScreen
	call StartScreen
	call ClearScreen
	call display_menu

	loopmenu:
	xor ax,ax
	mov  ah, 7
    int  21h
	
	.IF al=='1'
		xor ax,ax
		call level1
	.ELSEIF al=='2'
		xor ax,ax
		call level2
	.ELSEIF al=='3'
		xor ax,ax
		call level3
    .ELSEIF al=='4'
		xor ax,ax
		call printingscore
		jmp loopmenu
	.ELSEIF al==27
		xor ax,ax
		jmp exit_game
	.ELSE
		jmp loopmenu
	.ENDIF

	mov ah,4ch
	int 21h
Main endp
;--------------------------------------------LEVELS-------------------------------------------------------------------------------------



;--------------------------------------DRAWING FUNCTIONS---------------------------------------------------------------------------

display_menu PROC USES AX DX
    mov  dx, offset menu
    mov  ah, 9
    int  21h

    ret
display_menu ENDP

namereader proc uses ax dx bx




	lea dx, fname1           ; Load address of String “file”
		mov al, 0                   ; Open file (read)
		mov ah, 3Dh                 ; Load File Handler and store in ax

		MOV DX, OFFSET FNAME
		int 21h
		mov rhandle, ax
	
	;READ FROM FILE
		mov bx, rhandle              ; Move file Handle to bx
		lea dx, fsaver         ; Load             
		mov ah, 3Fh                 ; Function to read from file
		int 21h
ret
namereader endp


printingscore proc uses ax dx  
	startscore:
		call ClearScreen
		lea dx, fsaver
		mov ah, 09h
		int 21h


		mov  dx, offset temper
    	mov  ah, 9
    	int  21h

		mov ah, 01h
		int 16h
		mov ah,00h
		int 16h

		.IF al==27
			call display_menu
			ret
		.ELSE
			jmp startscore
		.ENDIF


ret
printingscore endp

StartScreen PROC
	drawPlayer 230,100

	mov ah,02h  ;set cursor
	mov dh,8
	mov dl,_cursor
	int 10h
	mov cx,28
	mov si,offset _welcome

	LoopWelcome:
	    push cx
	    mov al,[si]
	    mov bh,0
	    mov bl,15
	    mov cx,1
	    mov ah,0Ah
	    int 10h
	    add si, TYPE _welcome
	    add _cursor,1
	    mov ah,02h
	    mov dh,8
	    mov dl,_cursor
	    int 10h

	    pop cx
	LOOP LoopWelcome

	mov _cursor,5
	mov ah,02h  ;set cursor
	mov dh,10
	mov dl,_cursor
	int 10h
	mov cx,30
	mov si,offset _enter

	LoopEnter:
	    push cx

	    mov al,[si]
	    mov bh,0
	    mov bl,15
	    mov cx,1
	    mov ah,0Ah
	    int 10h
	    add si, TYPE _enter
	    inc _cursor
	    mov ah,02h
	    mov dh,10
	    mov dl,_cursor
	    int 10h

	    pop cx
	LOOP LoopEnter


	mov _cursor,16
	mov ah,02h  ;set cursor
	mov dh,12
	mov dl,_cursor
	int 10h
	mov cx,8
	mov si,offset _name
	LoopName:
	    push cx

	    mov ah,01h
	    int 21h
	    mov [si],al
	    add si, TYPE _name
	    inc _cursor
	    mov ah,02h
	    mov dh,12
	    mov dl,_cursor
	    int 10h

	    pop cx
	LOOP LoopName
    ;========================file handling========================
			;===========file creation=====================
	MOV AH,3CH 		;3ch: file creation, 3eh: file closes
	MOV CL,2		;to write/read
	
	MOV DX, OFFSET FNAME
	INT 21H
	MOV FHANDLE,AX


	;LOAD FILE HANDLE
		lea dx, fname         ; Load address of String “file”
		mov al, 2                   ; Open file (write/read)
		mov ah, 3Dh                 ; Load File Handler and store in ax
		int 21h
		mov fhandle, ax
	
			
;WRITE IN FILE
		mov cx, LENGTHOF _name       ; Number of bytes to write
		mov bx, fhandle              ; Move file Handle to bx
		lea dx, _name               ; Load offset of string which is to be written to file
		mov ah, 40h                 ; Write to file
		int 21h
		
ret
StartScreen endp

;---------------------------------------------------------------------------------------------------------------------------



; Level 1
level1 PROC
	; Background color
		mov ah, 06h 
		mov al, 0
		mov bh, 0
		mov bl, 0
		mov cx,0
		mov dh,50
		mov dl,50
		int 10h
	; ----------------

	call initEnemyTypes ; randomize enemy types
	call initEnemyCoords ; initialize initial enemy coordinates


	level1_loop:   ; Infinite loop for level 1
		call ClearScreen
		call score_fun
		drawPlayer sprite_y,move_x
		call drawAllEnemies
		call drawAllBullets
		call update_jump_player
		call update_bullets
		call update_enemies
		call get_inputs
		call check_bullet_impact
		call check_end_game
									
		inc counter
		inc counter_two

	jmp level1_loop

	ret 
level1 ENDP


; Level 2
level2 PROC
	; Background color
		mov ah, 06h 
		mov al, 0
		mov bh, 0
		mov bl, 0
		mov cx,0
		mov dh,50
		mov dl,50
		int 10h
	; ----------------

	call initEnemyTypes ; randomize enemy types
	call generateRandomNumberBinary
	.IF rand_num_binary==0 ;randomizing enemy pattern
		call initEnemyCoords
	.ELSE
		call initEnemyCoordsRand
	.ENDIF


	level2_loop:   ; Infinite loop for level 2
		call ClearScreen
		call score_fun
		drawPlayer sprite_y,move_x
		call drawAllEnemies
		call drawAllBullets
		call update_jump_player
		call update_bullets
		call update_enemies
		call enemy_movement ; level 2 feature, enemies move left right
		call get_inputs
		call check_bullet_impact
		call check_end_game
									
		inc counter
		inc counter_two
	jmp level2_loop

	ret 
level2 ENDP


; Level 3
level3 PROC
	; Background color
		mov ah, 06h 
		mov al, 0
		mov bh, 0
		mov bl, 0
		mov cx,0
		mov dh,50
		mov dl,50
		int 10h
	; ----------------

	call initEnemyTypes ; randomize enemy types
	call heart_init
	call generateRandomNumberBinary
	.IF rand_num_binary==0 ;randomizing enemy pattern
		call initEnemyCoords
	.ELSE
		call initEnemyCoordsRand
	.ENDIF


	level3_loop:   ; Infinite loop for level 2
		call ClearScreen
		call score_fun
		drawPlayer sprite_y,move_x
		call drawAllEnemies
		call heart_draw
		
		;draw score===================================
	
		call drawAllBullets
		call update_jump_player
		call update_bullets
		call update_enemies
		call enemy_special ; special enemy
		call draw_enemy_special ; draw special enemy
		call update_enemy_special ; update special enemy position
		call collision_enemy_special ; special enemy collision with player

		call enemy_monster
		call draw_enemy_monster
		call update_enemy_monster
		call fire_bullet_enemy_monster
		call update_bullet_enemy_monster
		call draw_bullet_enemy_monster
		call check_bullet_impact_enemy_monster

		call enemy_movement ; level 2 feature, enemies move left right
		call get_inputs
		call check_bullet_impact
		call check_end_game
									
		inc counter
		inc counter_two
	jmp level3_loop

	ret 
level3 ENDP

;-----------------------------------------------------------------------------------------------------------------------------
score_fun proc uses ax cx dx
mov ah,02h  ;set cursor
	mov _cursor,0
	mov dh,0
	mov dl,_cursor
	int 10h
	mov cx,7
	mov si,offset score_string

	Loopscore:
	    push cx
	    mov al,[si]
	    mov bh,0
	    mov bl,15
	    mov cx,1
	    mov ah,0Ah
	    int 10h
	    add si, TYPE score_string
	    add _cursor,1
	    mov ah,02h
	    mov dh,0
	    mov dl,_cursor
	    int 10h

	    pop cx
	LOOP Loopscore
		mov dx,score
		add dx,'0'
		mov ah,02h 
		int 21h

  ret
score_fun ENDP


ClearScreen PROC uses ax bx cx dx   ;clear screen
		mov ah, 06h 
		mov al, 0
		mov bh, 0
		mov bl, 0
		mov cx,0
		mov dh,50
		mov dl,50
		int 10h
	ret 	
ClearScreen ENDP

;move player spaceship right
move_player_right PROC USES AX
	mov ax,move_x
	.IF ax<=800
		add ax,3
		mov move_x,ax
	.ENDIF

	ret
move_player_right ENDP

;move player spaceship left
move_player_left PROC USES AX
	mov ax,move_x
	.IF ax>=520
		sub ax,3
		mov move_x,ax
	.ENDIF

	ret
move_player_left ENDP

;jump player
jump_player PROC
	.IF player_jump_flag==0
		mov player_jump_flag,1
	.ENDIF
	ret
jump_player ENDP

;update jump status
update_jump_player PROC
	.IF player_jump_flag==1
		.IF counter_jump==20
			mov counter_jump,0
			mov player_jump_flag,0 ;jump finished
		.ELSE
			inc counter_jump
		.ENDIF
	.ENDIF
	ret
update_jump_player ENDP


;generate a random number between 0 and 9
randomNumber PROC USES AX BX DX
	mov ah,0h
	int 1ah

	mov ax,dx
	mov dx,0
	mov bx,10
	div bx
	
	mov rand_num,dl
	ret
randomNumber ENDP

;generate a random number between 0 and 1
randomNumberBinary PROC USES AX BX DX
	mov ah,0h
	int 1ah

	mov ax,dx
	mov dx,0
	mov bx,2
	div bx
	
	mov rand_num_binary,dl
	ret
randomNumberBinary ENDP

;add delay
delay PROC USES cx
	mov cx,1
	startDelay:
		cmp cx, 50000
		je endDelay
		inc cx
		jmp startDelay
	endDelay:
	ret
delay ENDP

;Wrapper function to add delay and then generate random number
;we will use this function to generate random numbers
generateRandomNumber PROC USES CX
	mov cx,8
	.WHILE cx>0
		call delay
		dec cx
	.ENDW
	call randomNumber
	ret
generateRandomNumber ENDP

;Wrapper function to add delay and then generate random number binary
;we will use this function to generate random numbers
generateRandomNumberBinary PROC USES CX
	mov cx,8
	.WHILE cx>0
		call delay
		dec cx
	.ENDW
	call randomNumberBinary
	ret
generateRandomNumberBinary ENDP

;Randomize enemy types
initEnemyTypes PROC USES AX BX CX DX
	xor cx,cx
	mov cl,0
	.WHILE cx<enemy_limit
		call generateRandomNumberBinary ;random number to store enemy type (b/w 0-1)

		mov al,SizeOfEnemy
		mov bl,cl
		mul bl
		xor bx,bx
		mov bl,al

		xor dx,dx
		mov dl,rand_num_binary
		mov	enemy[bx].num,dx

		inc cx
	.ENDW

	ret
initEnemyTypes ENDP

;initialize enemy coordinates
initEnemyCoords PROC 
	mov enemy[0*SizeOfEnemy].x,500+30
	mov enemy[0*SizeOfEnemy].y,430

	mov enemy[1*SizeOfEnemy].x,550+30
	mov enemy[1*SizeOfEnemy].y,430

	mov enemy[2*SizeOfEnemy].x,600+30
	mov enemy[2*SizeOfEnemy].y,430

	mov enemy[3*SizeOfEnemy].x,650+30
	mov enemy[3*SizeOfEnemy].y,430

	mov enemy[4*SizeOfEnemy].x,700+30
	mov enemy[4*SizeOfEnemy].y,430

	mov enemy[5*SizeOfEnemy].x,500+30
	mov enemy[5*SizeOfEnemy].y,430+80

	mov enemy[6*SizeOfEnemy].x,550+30
	mov enemy[6*SizeOfEnemy].y,430+80

	mov enemy[7*SizeOfEnemy].x,600+30
	mov enemy[7*SizeOfEnemy].y,430+80

	mov enemy[8*SizeOfEnemy].x,650+30
	mov enemy[8*SizeOfEnemy].y,430+80

	mov enemy[9*SizeOfEnemy].x,700+30
	mov enemy[9*SizeOfEnemy].y,430+80

	ret
initEnemyCoords ENDP

;random initialize enemy coordinates
initEnemyCoordsRand PROC 
	mov enemy[0*SizeOfEnemy].x,500+30
	mov enemy[0*SizeOfEnemy].y,430

	mov enemy[1*SizeOfEnemy].x,550+30
	mov enemy[1*SizeOfEnemy].y,430

	mov enemy[2*SizeOfEnemy].x,600+30
	mov enemy[2*SizeOfEnemy].y,430

	mov enemy[3*SizeOfEnemy].x,650+30
	mov enemy[3*SizeOfEnemy].y,430

	mov enemy[4*SizeOfEnemy].x,500+30
	mov enemy[4*SizeOfEnemy].y,430+40

	mov enemy[5*SizeOfEnemy].x,550+30
	mov enemy[5*SizeOfEnemy].y,430+40

	mov enemy[6*SizeOfEnemy].x,600+30
	mov enemy[6*SizeOfEnemy].y,430+40

	mov enemy[7*SizeOfEnemy].x,500+30
	mov enemy[7*SizeOfEnemy].y,430+80

	mov enemy[8*SizeOfEnemy].x,550+30
	mov enemy[8*SizeOfEnemy].y,430+80

	mov enemy[9*SizeOfEnemy].x,600+30
	mov enemy[9*SizeOfEnemy].y,430+80


	ret
initEnemyCoordsRand ENDP

;drawing all enemies
drawAllEnemies PROC USES AX BX DX
	.IF enemy[0*SizeOfEnemy].flag==1
		.IF enemy[0*SizeOfEnemy].num==0
		drawEnemy enemy[0*SizeOfEnemy].y,enemy[0*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[0*SizeOfEnemy].y,enemy[0*SizeOfEnemy].x,enemyTwo
		.ENDIF		
	.ENDIF

	.IF  enemy[1*SizeOfEnemy].flag==1
		.IF enemy[1*SizeOfEnemy].num==0
			drawEnemy enemy[1*SizeOfEnemy].y,enemy[1*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[1*SizeOfEnemy].y,enemy[1*SizeOfEnemy].x,enemyTwo
		.ENDIF	
	.ENDIF

	.IF enemy[2*SizeOfEnemy].flag==1
		.IF enemy[2*SizeOfEnemy].num==0
			drawEnemy enemy[2*SizeOfEnemy].y,enemy[2*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[2*SizeOfEnemy].y,enemy[2*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	.IF enemy[3*SizeOfEnemy].flag==1
		.IF enemy[3*SizeOfEnemy].num==0
			drawEnemy enemy[3*SizeOfEnemy].y,enemy[3*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[3*SizeOfEnemy].y,enemy[3*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	.IF enemy[4*SizeOfEnemy].flag==1
		.IF enemy[4*SizeOfEnemy].num==0
			drawEnemy enemy[4*SizeOfEnemy].y,enemy[4*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[4*SizeOfEnemy].y,enemy[4*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	.IF enemy[5*SizeOfEnemy].flag==1
		.IF enemy[5*SizeOfEnemy].num==0
			drawEnemy enemy[5*SizeOfEnemy].y,enemy[5*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[5*SizeOfEnemy].y,enemy[5*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	.IF enemy[6*SizeOfEnemy].flag==1
		.IF enemy[6*SizeOfEnemy].num==0
			drawEnemy enemy[6*SizeOfEnemy].y,enemy[6*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[6*SizeOfEnemy].y,enemy[6*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	.IF enemy[7*SizeOfEnemy].flag==1
		.IF enemy[7*SizeOfEnemy].num==0
			drawEnemy enemy[7*SizeOfEnemy].y,enemy[7*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[7*SizeOfEnemy].y,enemy[7*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	.IF enemy[8*SizeOfEnemy].flag==1
		.IF enemy[8*SizeOfEnemy].num==0
			drawEnemy enemy[8*SizeOfEnemy].y,enemy[8*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[8*SizeOfEnemy].y,enemy[8*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	.IF enemy[9*SizeOfEnemy].flag==1
		.IF enemy[9*SizeOfEnemy].num==0
			drawEnemy enemy[9*SizeOfEnemy].y,enemy[9*SizeOfEnemy].x,enemyOne
		.ELSE
			drawEnemy enemy[9*SizeOfEnemy].y,enemy[9*SizeOfEnemy].x,enemyTwo
		.ENDIF
	.ENDIF

	ret
drawAllEnemies ENDP

;drawing bullets
drawAllBullets PROC USES AX BX DX
	.IF bullet[0*SizeOfBullet].flag==1
		drawBullet bullet[0*SizeOfBullet].y,bullet[0*SizeOfBullet].x
	.ENDIF

	.IF bullet[1*SizeOfBullet].flag==1
		drawBullet bullet[1*SizeOfBullet].y,bullet[1*SizeOfBullet].x
	.ENDIF

	.IF bullet[2*SizeOfBullet].flag==1
		drawBullet bullet[2*SizeOfBullet].y,bullet[2*SizeOfBullet].x
	.ENDIF

	.IF bullet[3*SizeOfBullet].flag==1
		drawBullet bullet[3*SizeOfBullet].y,bullet[3*SizeOfBullet].x
	.ENDIF

	ret
drawAllBullets ENDP

;fire bullet
fire_bullet PROC USES AX BX CX
	mov cx,bullet_count
	.IF cx<bullet_limit
		.WHILE cx<bullet_limit
			xor ax,ax
			mov al,SizeOfBullet
			mov bl,cl
			mul bl
			xor bx,bx
			mov bl,al
			.IF bullet[bx].flag==0
				call playSound
				mov bullet[bx].flag,1

				xor ax,ax
				mov ax,move_x
				mov bullet[bx].x,ax

				xor ax,ax
				mov ax,sprite_y
				mov bullet[bx].y,ax

				mov bx,bullet_count
				add bx,1
				mov bullet_count,bx

				jmp break
			.ENDIF
			inc cx
		.ENDW
	.ELSE
		call ClearScreen
		mov dx,cx
		add dx,'0'
		mov ah,02h
		int 21h
	.ENDIF

	break:
	ret
fire_bullet ENDP

;update position of bullets
update_bullets PROC USES AX BX CX
	xor ax,ax
	xor bx,bx
	mov ax,counter
	mov bl,3
	div bl
	.IF AH==0
		mov counter,0
		xor cx,cx
		.WHILE cx<bullet_limit
			mov al,SizeOfBullet
			mov bl,cl
			mul bl
			xor bx,bx
			mov bl,al
			.IF bullet[bx].flag==1
				.IF bullet[bx].y<420
					mov bullet[bx].flag,0 ;setting flag to 0 so as to not draw this bullet
					mov bullet[bx].x,0
					mov bullet[bx].y,0

					;decreasing bullet count
					mov ax,bullet_count 
					sub ax,1
					mov bullet_count,ax
				.ENDIF
				sub bullet[bx].y,10
			.ENDIF
			inc cx
		.ENDW
	.ENDIF

	ret
update_bullets ENDP

;update position of enemies
update_enemies PROC USES AX BX CX
	xor ax,ax
	xor bx,bx
	mov ax,counter_two
	mov bl,127
	div bl
	.IF AH==0
		mov counter_two,0
		xor cx,cx
		.WHILE cx<enemy_limit
			mov al,SizeOfEnemy
			mov bl,cl
			mul bl
			xor bx,bx
			mov bl,al
			.IF enemy[bx].flag==1
				add enemy[bx].y,2

				;checking if enemies reached bottom of screen, if so then exit game
				mov ax,enemy[bx].y
				add ax,10
				.IF ax>=sprite_y
					jmp exit_game ;exit game
				.ENDIF				
			.ENDIF
			inc cx
		.ENDW
	.ENDIF

	ret
update_enemies ENDP

;Procedure to get inputs and perform respective action on them
get_inputs PROC USES AX
	push CX
	push DX
	mov ah, 01h
	int 16h
	jnz keypressed
	pop DX
	pop CX
	xor cx,cx
	.WHILE cx<=5
		call delay
		inc cx
	.ENDW
	ret

	keypressed:
	mov ah,00h
	int 16h
	.IF al=='d'
		call move_player_right
	.ELSEIF al=='a'
		call move_player_left
	.ELSEIF al=='w' ;jump player on w key press
		call jump_player
	.ELSEIF al==27 ;exit game on escape key press
		jmp exit_game
	.ELSEIF al==32 ;fire on space key press
		call fire_bullet
	.ENDIF
	pop DX
	pop CX
	ret
get_inputs ENDP

;Procedure to check if any bullet is hitting enemy
check_bullet_impact PROC USES AX BX CX
	xor cx,cx
	.WHILE cx<bullet_limit
		mov al,SizeOfBullet
		mov bl,cl
		mul bl
		xor bx,bx
		mov bl,al
		.IF bullet[bx].flag==1
			mov si,bx
			push CX
			xor cx,cx
			xor ax,ax
			.WHILE cx<enemy_limit
				mov al,SizeOfEnemy
				mov bl,cl
				mul bl
				xor bx,bx
				mov bl,al

				xor ax,ax
				mov ax,enemy[bx].x
				.IF bullet[si].x>=ax
					add ax,16
				.IF bullet[si].x <= ax
					.IF enemy[bx].flag==1
						xor ax,ax
						mov ax,enemy[bx].y
						.IF bullet[si].y<=ax
							mov bullet[si].flag,0
							mov enemy[bx].flag,0
							drawExplosion enemy[bx].y,enemy[bx].x
							
							mov ax,enemy_count ;decrease enemy count
							.IF ax>0
								sub ax,1
								mov enemy_count,ax
							.ENDIF

							mov ax,bullet_count
							sub ax,1
							mov bullet_count,ax ;decrease bullet count	
							xor ax,ax
							mov ax,score
							add ax,1			;score update 
							mov score,ax
							.ENDIF
						.ENDIF
					.ENDIF
				.ENDIF
				inc cx
			.ENDW
			pop CX
		.ENDIF
		inc cx
	.ENDW

	ret
check_bullet_impact ENDP

;check if game ends, if enemies are 0
check_end_game PROC USES AX
	mov ax,enemy_count
	.IF ax==0
		jmp exit_game
	.ENDIF
	ret
check_end_game ENDP

;random enemy movement
enemy_movement PROC USES AX BX
	call generateRandomNumber
	xor bx,bx
	mov al,SizeOfEnemy
	mov bl,rand_num
	mul bl
	xor bx,bx
	mov bl,al
	.IF enemy[bx].flag==1
		call generateRandomNumber
		mov al,rand_num
		;520,800 are x,y limits of screen
		.IF enemy[bx].x<=530 ;left edge of screen, move right only
			add enemy[bx].x,5
			jmp nomove
		.ELSEIF enemy[bx].x>=790 ;at right edge of screen, move left only
			sub enemy[bx].x,5
			jmp nomove
		.ENDIF

		.IF al==0
			add enemy[bx].x,5	
		.ELSEIF al==1
			sub enemy[bx].x,5
		.ENDIF				
	.ENDIF
	nomove:
	ret
enemy_movement ENDP

;init special enemy
enemy_special PROC USES BX CX DX
	xor cx,cx
	mov cx,enemy_special_flag
	.IF cx==0 ; if special enemy does not exist
		call generateRandomNumber
		xor bx,bx
		mov bl,rand_num
		.IF bx==5 ;if random num is 5, then only draw special enemy
			mov enemy_special_x,510
			mov dx,sprite_y
			mov enemy_special_y,dx
			mov enemy_special_flag,1
		.ENDIF
	.ENDIF

	ret
enemy_special ENDP

;update special enemy
update_enemy_special PROC USES AX BX
	mov ax,enemy_special_flag
	.IF ax==1 ;special enemy exists
		xor ax,ax
		xor bx,bx
		mov ax,counter_two
		mov bl,1
		div bl
		.IF AH==0
			mov bx,enemy_special_x
			add bx,3
			mov enemy_special_x,bx
		.ENDIF
		.IF enemy_special_x >=790 ;if special enemy is at edge of screen, destroy it and reset its coords
			mov enemy_special_x,510
			mov dx,sprite_y
			mov enemy_special_y,dx
			mov enemy_special_flag,0
		.ENDIF
	.ENDIF

	ret
update_enemy_special ENDP

;special enemy collision with player
collision_enemy_special PROC USES AX BX
	mov ax,enemy_special_flag
	.IF ax==1 ;special enemy exists
		mov bx,enemy_special_x
		mov ax,move_x
		add ax,16

		.IF bx>=ax ;if special enemy x==player x, end game
			.IF bx<=ax ;if special enemy x==player x, end game
				mov ax,player_jump_flag
				.IF player_jump_flag==0 ;if player not jumping
					call decrement_lives
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF

	ret
collision_enemy_special ENDP

;wrapper function to draw special enemy
draw_enemy_special PROC USES AX
	mov ax,enemy_special_flag
	.IF ax==1 ;special enemy exists
		drawEnemySpecial enemy_special_y,enemy_special_x
	.ENDIF

	ret
draw_enemy_special ENDP

;init enemy monster
enemy_monster PROC USES AX
	mov ax,enemy_monster_flag
	.IF ax==0 ;enemy monster does not exist
		mov enemy_monster_flag,1
		mov enemy_monster_x,600
		mov enemy_monster_y,430
	.ENDIF

	ret
enemy_monster ENDP

;update enemy monster
update_enemy_monster PROC USES AX BX
	mov ax,enemy_monster_flag
	.IF ax==1 ;monster enemy exists
		xor ax,ax
		xor bx,bx
		mov ax,counter_two
		mov bl,5
		div bl
		.IF AH==0
			mov bx,enemy_monster_x
			call generateRandomNumberBinary
			.IF rand_num_binary==0
				add bx,3
			.ELSE
				sub bx,3 
			.ENDIF
			mov enemy_monster_x,bx
		.ENDIF
	.ENDIF

	ret
update_enemy_monster ENDP

;draw enemy monster
draw_enemy_monster PROC USES AX
	mov ax,enemy_monster_flag
	.IF ax==1 ;if enemy monster exists
		drawEnemyMonster enemy_monster_y,enemy_monster_x
	.ENDIF

	ret
draw_enemy_monster ENDP

;enemy monster firing
fire_bullet_enemy_monster PROC USES AX BX
	mov ax,enemy_monster_bullet_flag
	.IF ax==0 ;monster only fire bullet if bullet bullet does not already exist
		mov enemy_monster_bullet_flag,1
		mov bx,enemy_monster_x
		mov enemy_monster_bullet_x,bx
		mov bx,enemy_monster_y
		mov enemy_monster_bullet_y,bx
	.ENDIF

	ret
fire_bullet_enemy_monster ENDP

;update monster bullet
update_bullet_enemy_monster PROC USES AX BX
	mov ax,enemy_monster_bullet_flag
	.IF ax==1 ; if enemy monster bullet exists
		xor ax,ax
		xor bx,bx
		mov ax,counter
		mov bl,3
		div bl
		.IF AH==0
			mov bx,enemy_monster_bullet_y
			add bx,10
			mov enemy_monster_bullet_y,bx
		.ENDIF
		mov bx,enemy_monster_bullet_y
		mov ax,sprite_y
		add ax,20
		.IF bx>=ax
			mov enemy_monster_bullet_flag,0
		.ENDIF
	.ENDIF

	ret
update_bullet_enemy_monster ENDP

;check if enemy monster bullet hits player
check_bullet_impact_enemy_monster PROC USES AX BX
	mov ax,enemy_monster_bullet_flag
	.IF ax==1 ;monster bullet exists
		mov bx,move_x
		.IF enemy_monster_bullet_x>=bx ;if bullet x matches player x
			add bx,16
			.IF enemy_monster_bullet_x<=bx
				mov bx,sprite_y
				.IF enemy_monster_bullet_y >=bx
					mov enemy_monster_bullet_flag,0
					call decrement_lives
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF

	ret
check_bullet_impact_enemy_monster ENDP

;draw monster bullet
draw_bullet_enemy_monster PROC USES AX
	mov ax,enemy_monster_bullet_flag
	.IF ax==1 ;if monster bullet exists, then only draw
		drawBulletMonster enemy_monster_bullet_y,enemy_monster_bullet_x
	.ENDIF

	ret
draw_bullet_enemy_monster ENDP

;decrement lives
decrement_lives PROC USES AX
	mov ax,heart_count
	.IF ax>0
		.IF ax==3
			sub ax,1
			mov heart[2*SizeOfHeart].flag,0
			mov heart_count,ax
		.ELSEIF ax==2
			sub ax,1
			mov heart[1*SizeOfHeart].flag,0
			mov heart_count,ax
		.ELSEIF ax==1
			sub ax,1
			mov heart[0*SizeOfHeart].flag,0
			mov heart_count,ax
		.ENDIF
	.ELSEIF ax==0 ;if lives are 0, exit game
		jmp exit_game
	.ENDIF
	ret
decrement_lives ENDP

;520,800

;initialize heart coords
heart_init PROC USES AX
	mov ax,sprite_y
	add ax,0

	mov heart[0*SizeOfHeart].flag,1
	mov heart[0*SizeOfHeart].x,770
	mov heart[0*SizeOfHeart].y,ax

	mov heart[1*SizeOfHeart].flag,1
	mov heart[1*SizeOfHeart].x,790
	mov heart[1*SizeOfHeart].y,ax

	mov heart[2*SizeOfHeart].flag,1
	mov heart[2*SizeOfHeart].x,810
	mov heart[2*SizeOfHeart].y,ax

	ret
heart_init ENDP

;draw heart
heart_draw PROC
	.IF heart[0*SizeOfHeart].flag==1
		drawHeart heart[0*SizeOfHeart].y,heart[0*SizeOfHeart].x
	.ENDIF
	.IF heart[1*SizeOfHeart].flag==1
		drawHeart heart[1*SizeOfHeart].y,heart[1*SizeOfHeart].x
	.ENDIF
	.IF heart[2*SizeOfHeart].flag==1
		drawHeart heart[2*SizeOfHeart].y,heart[2*SizeOfHeart].x
	.ENDIF
	ret
heart_draw ENDP


;play sound on fire
playSound PROC USES AX BX DX CX
	MOV	DX,10000	; Number of times to repeat whole routine.

	MOV	BX,1		; Frequency value.

	MOV	AL, 10110110B	; The Magic Number (use this binary number only)
	OUT     43H, AL          ; Send it to the initializing port 43H Timer 2.

	NEXT_FREQUENCY:          ; This is were we will jump back to 2000 times.

	MOV     AX, BX           ; Move our Frequency value into AX.

	OUT     42H, AL          ; Send LSB to port 42H.
	MOV     AL, AH           ; Move MSB into AL  
	OUT     42H, AL          ; Send MSB to port 42H.

	IN      AL, 61H          ; Get current value of port 61H.
	OR      AL, 00000011B    ; OR AL to this value, forcing first two bits high.
	OUT     61H, AL          ; Copy it to port 61H of the PPI Chip
							; to turn ON the speaker.

	MOV     CX, 100          ; Repeat loop 100 times
	DELAY_LOOP:              ; Here is where we loop back too.
	LOOP    DELAY_LOOP       ; Jump repeatedly to DELAY_LOOP until CX = 0


	INC     BX               ; Incrementing the value of BX lowers 
							; the frequency each time we repeat the
							; whole routine

	DEC     DX               ; Decrement repeat routine count

	CMP     DX, 0            ; Is DX (repeat count) = to 0
	JNZ     NEXT_FREQUENCY   ; If not jump to NEXT_FREQUENCY
							; and do whole routine again.

							; Else DX = 0 time to turn speaker OFF

	IN      AL,61H           ; Get current value of port 61H.
	AND	AL,11111100B	; AND AL to this value, forcing first two bits low.
	OUT     61H,AL           ; Copy it to port 61H of the PPI Chip
							; to turn OFF the speaker.
	ret 	
playSound ENDP


;end
exit_game:
	call ClearScreen
	xor ah,ah
	;setting graphic mode back to text mode
	mov al,3
	int 10h
	    ;================== SCORE SAVING
		MOV AH,3CH 		;3ch: file creation, 3eh: file closes
		MOV CL,2		;to write/read
	
		MOV DX, OFFSET FNAME1
		INT 21H
		MOV FHANDLE1,AX


		;LOAD FILE HANDLE
		lea dx, fname1         ; Load address of String “file”
		mov al, 2                   ; Open file (write/read)
		mov ah, 3Dh                 ; Load File Handler and store in ax
		int 21h
		mov fhandle1, ax
	
			
		;WRITE IN FILE
		mov cx, LENGTHOF score      ; Number of bytes to write
		mov bx, fhandle1   
		mov ax,score           ; Move file Handle to bx
		add ax,'0'
		mov score,ax
		lea dx, score            ; Load offset of string which is to be written to file
		mov ah, 40h                 ; Write to file
		int 21h

		;CLOSE FILE HANDLE
		mov ah, 3Eh
		mov bx, fhandle1
		int 21h
		;=========================================
	mov ah,4ch
	int 21h

End Main




.IF al==27
			call display_menu
			ret
		.ELSE
			jmp startscore
		.ENDIF