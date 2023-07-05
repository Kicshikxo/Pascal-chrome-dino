Unit Game;

interface

uses System, System.Drawing, System.Windows.Forms, Sounds;

type
  MainForm = class(Form)
    procedure Draw();
    procedure Restart();
    procedure UpdateScore();
    function isDinoCollided():boolean;
    procedure MainForm_Load(sender: Object; e: EventArgs);
    procedure MainTimer_Tick(sender: Object; e: EventArgs);
    procedure MainForm_KeyUp(sender: Object; e: KeyEventArgs);
    procedure MainForm_KeyDown(sender: Object; e: KeyEventArgs);
    procedure MainPictureBox_MouseDown(sender: Object; e: MouseEventArgs);
  {$region FormDesigner}
  internal
    {$resource Game.MainForm.resources}
    components: System.ComponentModel.IContainer;
    MainTimer: Timer;
    ScoreLabel: &Label;
    HighScoreLabel: &Label;
    MainPictureBox: PictureBox;
    {$include Game.MainForm.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  end;
  
  InfinitelyMovingGroundPart = class
    width, height: integer;
    x, y: real;
    sprite: Image;
    constructor (pictureHeight: integer; x: real);
    begin
      self.sprite := Image.FromFile('sprites/ground.png');
      self.Width  := self.sprite.width;
      self.Height := self.sprite.height;
      self.x := x;
      self.y := pictureHeight - self.Height;
    end;
    procedure move(speed: real);
    begin
      self.x -= speed;
    end;
  end;
  
  
  InfinitelyMovingGround = class
    parts: array of InfinitelyMovingGroundPart;
    pictureWidth, pictureHeight: integer;
    constructor(pictureWidth, pictureHeight, spriteWidth: integer);
    begin
      self.pictureWidth  := pictureWidth;
      self.pictureHeight := pictureHeight;
      self.parts := Arr(
         new InfinitelyMovingGroundPart(pictureHeight, 0),
         new InfinitelyMovingGroundPart(pictureHeight, spriteWidth)
      )
    end;
    procedure move(speed: real);
    begin
      foreach var part in self.parts do begin
        part.move(speed);
        if (part.x <= -part.width) then begin
          part.x := part.width - speed * 2;
        end;
      end;
    end;
  end;
  
  
  SoundConrollerClass = class
    private jumpSound, boostSound, loseSound: Sound;
    constructor();
    begin
      self.initSounds;
    end;
    procedure initSounds();
    begin
      self.jumpSound  := new Sound('sounds/jump.mp3');
      self.boostSound := new Sound('sounds/boost.mp3');
      self.loseSound  := new Sound('sounds/lose.mp3');
    end;
    procedure playJumpSound();
    begin
      self.jumpSound.Reset;
      self.jumpSound.Play;
    end;
    procedure playBoostSound();
    begin
      self.boostSound.Reset;
      self.boostSound.Play;
    end;
    procedure playLoseSound();
    begin
      self.loseSound.Reset;
      self.loseSound.Play;
    end;
  end;
  
  
  CactusClass = class
    x, y: real;
    width, height: integer;
    sprite: Image;
    constructor(pictureWidth, pictureHeight: integer; sprite: Image);
    begin
      self.sprite := sprite;
      self.width  := sprite.Width;
      self.height := sprite.Height;
      self.x := pictureWidth  + self.width;
      self.y := pictureHeight - self.height;
    end;
    procedure move(speed: real);
    begin
      self.x -= speed;
    end;
  end;
  
  
  CactusControllerClass = class
    cactuses: List<CactusClass> := new List<CactusClass>;
    cactusesToRemove: List<CactusClass> := new List<CactusClass>;
    pictureWidth, pictureHeight: integer;
    framesAfterLastSpawn: integer;
    lastRandomType: integer;
    smallCactusSprite, twoSmallCactusSprite, tripleSmallCactusSprite, tripleCactusSprite, bigCactusSprite, twoBigCactusSprite: Image;
    constructor(pictureWidth, pictureHeight: integer);
    begin
      self.pictureWidth  := pictureWidth;
      self.pictureHeight := pictureHeight;
      self.initImages;
    end;
    procedure initImages();
    begin
      self.smallCactusSprite       := Image.FromFile('sprites/cactus-small.png');
      self.twoSmallCactusSprite    := Image.FromFile('sprites/cactus-two-small.png');
      self.tripleSmallCactusSprite := Image.FromFile('sprites/cactus-triple-small.png');
      self.tripleCactusSprite      := Image.FromFile('sprites/cactus-triple.png');
      self.bigCactusSprite         := Image.FromFile('sprites/cactus-big.png');
      self.twoBigCactusSprite      := Image.FromFile('sprites/cactus-two-big.png');
    end;
    procedure addCactus(cactusType: integer);
    begin
      var newCactus: CactusClass;
      
      if (cactusType = 0) then 
        newCactus := new CactusClass(self.pictureWidth, self.pictureHeight, self.smallCactusSprite)
      else if (cactusType = 1) then 
        newCactus := new CactusClass(self.pictureWidth, self.pictureHeight, self.twoSmallCactusSprite)
      else if (cactusType = 2) then 
        newCactus := new CactusClass(self.pictureWidth, self.pictureHeight, self.tripleSmallCactusSprite)
      else if (cactusType = 3) then 
        newCactus := new CactusClass(self.pictureWidth, self.pictureHeight, self.tripleCactusSprite)
      else if (cactusType = 4) then 
        newCactus := new CactusClass(self.pictureWidth, self.pictureHeight, self.bigCactusSprite)
      else if (cactusType = 5) then 
        newCactus := new CactusClass(self.pictureWidth, self.pictureHeight, self.twoBigCactusSprite);
      
      self.cactuses.Add(newCactus);
      self.framesAfterLastSpawn := 0;
    end;
    procedure addRandomCactus();
    begin
      var randomType := PABCSystem.Random(6);
      if (randomType = self.lastRandomType) then begin
        self.addRandomCactus;
        exit;
      end;
      self.lastRandomType := randomType;
      addCactus(randomType);
    end;
    procedure randomSpawn(speed: real);
    begin
      if (
        (self.cactuses.Count = 0) or 
        (self.framesAfterLastSpawn > 100) or 
        ((self.framesAfterLastSpawn > 10) and ((PABCSystem.random(500 - speed) = 0))) or
        ((self.framesAfterLastSpawn > 50 - speed * 1.25) and (PABCSystem.random(100 - speed) < speed / 2))
      ) then begin
        self.addRandomCactus;
      end;
    end;
    procedure removeCactus(cactus: CactusClass);
    begin
      self.cactuses.Remove(cactus);
    end;
    procedure move(speed: real);
    begin
      foreach var cactus in self.cactuses do begin
        cactus.move(speed);
        if (cactus.x + cactus.width * 2 < 0) then begin
          self.cactusesToRemove.Add(cactus);
        end;
      end;
      cactusesToRemove.ForEach(self.removeCactus);
    end;
  end;
  
  
  CloudClass = class
    x, y: real;
    width, height: integer;
    sprite: Image;
    constructor(pictureWidth, pictureHeight: integer);
    begin
      self.sprite := Image.FromFile('sprites/cloud-sprite.png');
      self.width := self.sprite.width;
      self.height := self.sprite.height;
      self.x := pictureWidth + self.width;
      self.y := PABCSystem.Random(0, pictureHeight / 2 - self.height); 
    end;
    procedure move(speed: real);
    begin
      self.x -= speed;
    end;
  end;
  
  
  CloudControllerClass = class
    pictureWidth, pictureHeight: integer;
    clouds: List<CloudClass> := new List<CloudClass>;
    cloudsToRemove: List<CloudClass> := new List<CloudClass>;
    framesAfterLastSpawn: integer;
    constructor(pictureWidth, pictureHeight: integer);
    begin
      self.pictureWidth := pictureWidth;
      self.pictureHeight := pictureHeight;
    end;
    procedure addCloud();
    begin
      self.clouds.Add(new CloudClass(self.pictureWidth, self.pictureHeight));
      self.framesAfterLastSpawn := 0;
    end;
    procedure randomSpawn(speed: real);
    begin
      if (
        (self.clouds.Count = 0) or 
        ((self.framesAfterLastSpawn > 100) and (PABCSystem.random(100) < 3))
      ) then begin
        self.addCloud;
      end;
    end;
    procedure removeCloud(cloud: CloudClass);
    begin
      self.clouds.Remove(cloud);
    end;
    procedure move(speed: real);
    begin
      foreach var cloud in self.clouds do begin
        cloud.move(speed / 3);
        if (cloud.x + cloud.width < 0) then begin
          self.cloudsToRemove.Add(cloud);
        end;
      end;
      cloudsToRemove.ForEach(self.removeCloud);
    end;
  end;
  
  
  GameOverScreenClass = class
    isShown: boolean;
    sprite: Image;
    width, height: integer;
    constructor();
    begin
      self.sprite := Image.fromFile('sprites/game-over-sprite.png');
      self.width := self.sprite.Width;
      self.height := self.sprite.Height;
    end;
    procedure show();
    begin
      isShown := true;
    end;
    procedure hide();
    begin
      isShown := false;
    end;
  end;
  
  
  DinoClass = class
    x, y, vy: real;
    width, height: integer;
    pictureWidth, pictureHeight: integer;
    initJumpVelocity: real := 10;
    gravity: real := 0.55;
    sprite, staySprite, runSprite1, runSprite2, deadSprite: Image;
    isJumping, isDead: boolean;
    soundController: SoundConrollerClass;
    colliderBox: Rectangle;
    colliderPadding: integer := 16;
    constructor (pictureWidth, pictureHeight: integer; soundController: SoundConrollerClass);
    begin
      self.initImages;
      self.width := self.sprite.width;
      self.height := self.sprite.height;
      self.pictureWidth := pictureWidth;
      self.pictureHeight := pictureHeight;
      self.x := 0;
      self.y := self.pictureHeight - self.height;
      self.colliderBox := new Rectangle(colliderPadding, 0, Round(self.width - colliderPadding * 2), self.height - colliderPadding);
      self.soundController := soundController;
    end;
    procedure initImages();
    begin
      self.staySprite := Image.FromFile('sprites/dino-stay.png');
      self.runSprite1 := Image.FromFile('sprites/dino-run-1.png');
      self.runSprite2 := Image.FromFile('sprites/dino-run-2.png');
      self.deadSprite := Image.FromFile('sprites/dino-dead.png');
      self.sprite := self.staySprite;
    end;
    procedure jump();
    begin
      if (not self.isJumping) then begin
        self.vy := self.initJumpVelocity;
        self.isJumping := true;
        self.sprite := self.staySprite;
        self.soundController.playJumpSound;
      end;
      if (self.isJumping) then begin
        self.vy -= self.gravity;
      end;
      self.y -= self.vy;
      if (self.y >= self.pictureHeight - self.height) then begin
        self.y := self.pictureHeight - self.height;
        self.isJumping := false;
        self.sprite := self.runSprite1;
      end;
    end;
    procedure died();
    begin
      self.sprite := self.deadSprite;
      self.isDead := true;
      self.soundController.playLoseSound;
    end;
  end;

implementation
var pictureSize := new Rectangle(10, -10, 600, 150); // (paddingX, paddingY, sizeX, sizeY)

var img := new Bitmap(pictureSize.Width, pictureSize.Height);
var gfx := Graphics.FromImage(img);
var pressedKeys:Dictionary<Keys, boolean> := Dict((Keys.Space, false));

var cloudController  := new CloudControllerClass(pictureSize.Width, pictureSize.Height);
var cactusController := new CactusControllerClass(pictureSize.Width, pictureSize.Height);
var soundController  := new SoundConrollerClass;
var ground           := new InfinitelyMovingGround(pictureSize.Width, pictureSize.Height, 1200);
var gameOverScreen   := new GameOverScreenClass();

var dino: DinoClass;

var score := 0;
var highScore := 0;

var speed:real;
var maxSpeed := 15;
var startSpeed := 5;
var speedIncrease := 0.01;

var firstStart := true;
var showHitboxes := false;

procedure MainForm.MainForm_Load(sender: Object; e: EventArgs);
begin
  gfx.InterpolationMode := System.Drawing.Drawing2D.InterpolationMode.NearestNeighbor;
  Restart;
  MainPictureBox.Image := img;
  Draw;
end;

procedure MainForm.Restart();
begin
  dino := new DinoClass(pictureSize.width, pictureSize.height, soundController);
  cactusController.cactuses.Clear;
  gameOverScreen.hide;
  score := 0;
  speed := startSpeed;
  if (not firstStart) then MainTimer.Start;
end;

procedure MainForm.Draw();
begin
  gfx.Clear(Color.Transparent);
  
  // Отрисовка земли
  foreach var part in ground.parts do begin
    if (part.x <= pictureSize.width) then begin
      gfx.DrawImage(part.sprite, part.x, part.y + pictureSize.y);
    end;
  end;
  
  // Отрисовка облаков
  foreach var cloud in cloudController.clouds do begin
    gfx.DrawImage(cloud.sprite, cloud.x, cloud.y);
  end;
  
  // Отрисовка кактусов
  foreach var cactus in cactusController.cactuses do begin
    gfx.DrawImage(cactus.sprite, cactus.x + pictureSize.x, cactus.y + pictureSize.y);
    if showHitboxes then gfx.DrawRectangle(Pens.Blue, cactus.x + pictureSize.x, cactus.y + pictureSize.y, cactus.width, cactus.height);
  end;
  
  // Отрисовка динозавра
  gfx.DrawImage(dino.sprite, dino.x + pictureSize.x, dino.y + pictureSize.y);
  if showHitboxes then gfx.DrawRectangle(Pens.Red, dino.x + pictureSize.x + dino.colliderBox.X, dino.y + pictureSize.y + dino.colliderBox.y, dino.x + dino.colliderBox.Width , dino.x + dino.colliderBox.height);
  // Отрисовка надписи
  if (gameOverScreen.isShown) then begin
    gfx.DrawImage(gameOverScreen.sprite, (pictureSize.width - gameOverScreen.width) / 2, (pictureSize.height - gameOverScreen.height) / 2);
  end;
  
  MainPictureBox.Invalidate;
end;

var framesPassed: integer;
var firstJumpFrames: integer;

procedure MainForm.MainTimer_Tick(sender: Object; e: EventArgs);
begin
  // Первый прыжок при старте
  if (firstStart) then begin
    if (firstJumpFrames > dino.initJumpVelocity / dino.gravity * 2 - 2) then begin
      firstJumpFrames := 0;
      firstStart := false;
    end;
    firstJumpFrames += 1;
    dino.jump;
    Draw;
    exit
  end;
  
  if (framesPassed > 5) then begin
    score += 1;
    UpdateScore;
    
    if (speed < maxSpeed) then 
      speed := Round(speed + speedIncrease, 3);
    
    if (not dino.isJumping) then begin
      if (dino.sprite = dino.runSprite1) then
        dino.sprite := dino.runSprite2
      else
        dino.sprite := dino.runSprite1;
    end;
    framesPassed := 0;
  end;
  framesPassed += 1;
  
  cactusController.randomSpawn(speed);
  cactusController.framesAfterLastSpawn += 1;

  cloudController.randomSpawn(speed);
  cloudController.framesAfterLastSpawn += 1;
  
  cactusController.move(speed);
  cloudController.move(speed);
  ground.move(speed);
  
  if (pressedKeys[Keys.Space] or dino.isJumping) then dino.jump;
  
  if (isDinoCollided) then begin
    gameOverScreen.show;
    MainTimer.Stop;
    dino.died;
    
    if (highScore = 0) then 
      highScoreLabel.Visible := true;
    if (score > highScore) then 
      highScore := score;
    UpdateScore;
  end;
       
  Draw;
end;

function MainForm.isDinoCollided():boolean;
begin
  foreach var cactus in cactusController.cactuses do begin
    if (cactus.x > dino.width + speed) then continue;
    
    if ( not (
      (dino.x + dino.colliderBox.X + dino.colliderBox.Width < cactus.x) or 
      (dino.x + dino.colliderBox.X > cactus.x + cactus.width) or 
      (dino.y + dino.colliderBox.Y + dino.colliderBox.Height < cactus.y)   or 
      (dino.y + dino.colliderBox.Y > cactus.y + cactus.height))) then begin
        Result := true;
        exit
    end;
  end;
  
  Result := false;
end;

procedure MainForm.UpdateScore();
begin
  ScoreLabel.Text := score.ToString.PadLeft(5, '0');
  if (highScore > 0) then begin
    highScoreLabel.Text := $'HI {highScore.ToString.PadLeft(5, Chr(48))}';
  end;
  
  if (score mod 100 = 0) then soundController.playBoostSound;
end;

procedure MainForm.MainForm_KeyDown(sender: Object; e: KeyEventArgs);
begin
   if (dino.isDead) then begin
     Restart;
     exit;
   end;
   if (firstStart) then MainTimer.Start;
   pressedKeys[e.KeyCode] := true 
end;

procedure MainForm.MainForm_KeyUp(sender: Object; e: KeyEventArgs);
begin pressedKeys[e.KeyCode] := false end;

procedure MainForm.MainPictureBox_MouseDown(sender: Object; e: MouseEventArgs);
begin if (dino.isDead) then Restart end;


end.
