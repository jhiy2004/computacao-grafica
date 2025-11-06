unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  ExtDlgs, StdCtrls;

TYPE
  Line = RECORD
    p1, p2 : TPoint;
  END;

  Polygon = RECORD
    edges : ARRAY OF Line;
  END;

  Material = record
    Kd: Double;  // Diffuse coefficient
    Ks: Double;  // Specular coefficient
    Color: TColor;
  end;

  Point3D = record
    x, y, z: Double;
  end;

  Sphere = record
    Center: Point3D;
    Radius: Double;
    Mat: Material;
  end;

  Plane = record
    Origin: Point3D;
    U, V: Point3D;
    Mat: Material;
  end;

  Light = record
    Pos: Point3D;
    I: Point3D;
  end;

  AmbientLight = record
    I: Point3D;
    K: Point3D;
  end;

  TLightArray = array of Light;
  TMatrix4x4 = array[0..3, 0..3] of Double;

type
  TMatriz = array of array of Double;

  { TForm1 }

  TForm1 = class(TForm)
    ExecutarButton: TButton;
    GrausLabel: TLabel;
    GrausEdit: TEdit;
    EixoLabel: TLabel;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    ShRadioButton: TRadioButton;
    Sh10: TEdit;
    Sh11: TEdit;
    Sh12: TEdit;
    Sh13: TEdit;
    Sh14: TEdit;
    Sh15: TEdit;
    Sh16: TEdit;
    Sh2: TEdit;
    Sh3: TEdit;
    Sh4: TEdit;
    Sh5: TEdit;
    Sh6: TEdit;
    Sh7: TEdit;
    Sh8: TEdit;
    Sh9: TEdit;
    SheLabel: TLabel;
    RotOrigemButton: TRadioButton;
    RotLabel: TLabel;
    RotCentroButton: TRadioButton;
    TransRadioButton: TRadioButton;
    TransLabel: TLabel;
    XEscalaEdit: TEdit;
    image: TImage;
    EscalaLabel: TLabel;
    GlobalEscalaEdit: TEdit;
    XTransEdit: TEdit;
    XEscalaLabel1: TLabel;
    EixoEdit: TEdit;
    Sh1: TEdit;
    YEscalaEdit: TEdit;
    XEscalaLabel: TLabel;
    YTransEdit: TEdit;
    YEscalaLabel1: TLabel;
    ZEscalaEdit: TEdit;
    YEscalaLabel: TLabel;
    ZTransEdit: TEdit;
    ZEscalaLabel: TLabel;
    mainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    pictureDialog: TOpenPictureDialog;
    operacoesMenu: TMenuItem;
    desenharMenuItem: TMenuItem;
    arquivoMenu: TMenuItem;
    abrirArquivo: TMenuItem;
    LocalRadioButton: TRadioButton;
    GlobalRadioButton: TRadioButton;
    ZEscalaLabel1: TLabel;
    procedure abrirArquivoClick(Sender: TObject);
    procedure CirculoGrausClick(Sender: TObject);
    procedure desenharMenuItemClick(Sender: TObject);
    procedure ExecutarButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GlobalRadioButtonChange(Sender: TObject);
    procedure LocalRadioButtonChange(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure RotCentroButtonChange(Sender: TObject);
    procedure RotOrigemButtonChange(Sender: TObject);
    procedure ShRadioButtonChange(Sender: TObject);
    procedure TransRadioButtonChange(Sender: TObject);
    procedure XEscalaEditChange(Sender: TObject);
    procedure imageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DesenharCirculoClick(Sender: TObject);
    procedure CirculoParametricoClick(Sender: TObject);
    procedure FloodFill4Click(Sender: TObject);
    procedure FloodFill8Click(Sender: TObject);
    procedure DesenharPoligonoClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure operacoesMenuClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MultiplicarMatrizes(const Matriz1, Matriz2: TMatriz; var MResultado: TMatriz);
    procedure ProjecaoOrtografica(const MC, MH: TMatriz; const canvasCenterX, CanvasCenterY: Integer);
    procedure LimparCanvas;
  private
  public
    procedure floodFill4(x, y : Integer; cor, borda : TColor);
    procedure floodFill8(x, y : Integer; cor, borda : TColor);
    procedure fillPolygon(p : Polygon);
    procedure lineBresenham(p1, p2 : TPoint);
    procedure InvertPixel(x, y: Integer);
    function  TransformPoint(const P: Point3D; const M: TMatrix4x4): Point3D;
    procedure ApplyTransformPlane(var P: Plane; const M: TMatrix4x4);
    procedure ApplyTransformSphere(var S: Sphere; const M: TMatrix4x4);
    function VectorSubtract(const A, B: Point3D): Point3D;
    function VectorAdd(const A, B: Point3D): Point3D;
    function VectorScale(const V: Point3D; S: Double): Point3D;
    function VectorLength(const V: Point3D): Double;
    function VectorNormalize(const V: Point3D): Point3D;
    function Dot(const A, B: Point3D): Double;
    function Reflect(const L, N: Point3D): Point3D;
    function Cross(const A, B: Point3D): Point3D;
    function IlluminationModel1(
      const ambient: AmbientLight;
      const lights: TLightArray;
      const m: Material;
      const angle: Double
    ): TColor;
  end;
const
  INSIDE = 0;  // 0000
  LEFT   = 1;  // 0001
  RIGHT  = 2;  // 0010
  BOTTOM = 4;  // 0100
  TOP    = 8;  // 1000

var
  Form1: TForm1;
  opt: integer;
  opt_projecao: integer;
  desenhar: boolean;
  p1: TPoint;
  p2: TPoint;
  poly: Polygon;
  hasPrevious: Boolean = False;
  previousPoint: TPoint;
  xmin: integer;
  xmax: integer;
  ymin: integer;
  ymax: integer;

function MinInt(a, b: Integer): Integer;
function MaxInt(a, b: Integer): Integer;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.abrirArquivoClick(Sender: TObject);
begin
  if pictureDialog.Execute then
  begin
    image.Picture.LoadFromFile(pictureDialog.FileName);
  end;
end;

procedure TForm1.CirculoGrausClick(Sender: TObject);
begin
  opt := 6;
end;

procedure TForm1.desenharMenuItemClick(Sender: TObject);
begin
  opt := 1;
end;

procedure TForm1.MultiplicarMatrizes(const Matriz1, Matriz2: TMatriz; var MResultado: TMatriz);
var b, c : Integer;
begin
  for b := 0 to 3 do
  begin
       MResultado[0,b] := 0;
       for c := 0 to 3 do
       begin
            MResultado[0,b] := MResultado[0,b] + Matriz1[0,c] * Matriz2[c,b];
       end;
  end;
end;

procedure TForm1.ExecutarButtonClick(Sender: TObject);
var
  a, b, c, cx, cy, cz : Integer;
  MC, MH, MHO, MHTPos, MHTNeg, MResultado, MResultadoO, MResultadoT : array of array of Double;
  canvasCenterX, canvasCenterY : Integer;
  aa, bb, cc, dd, ee, ff, gg, hh, ii, jj, kk, ll, mm, nn, oo, pp : Double;
begin
  // Escala Local
  if (opt_projecao = 1) and (opt = 11) then
  begin
    aa := StrToFloat(XEscalaEdit.Text);
    bb := StrToFloat(YEscalaEdit.Text);
    cc := StrToFloat(ZEscalaEdit.Text);
    canvasCenterX := Image.Width div 2;
    canvasCenterY := Image.Height div 2;

    SetLength(MC, 1, 4);
    SetLength(MH, 4, 4);
    for a := 0 to 3 do
    begin
         for b := 0 to 3 do
         begin
              MH[a,b] := 0;
         end;
    end;
    MH[0,0] := 1 * aa;
    MH[1,1] := 1 * bb;
    MH[2,2] := 1 * cc;
    MH[3,3] := 1;

    LimparCanvas;
    opt := 11;

    ProjecaoOrtografica(MC, MH, canvasCenterX, canvasCenterY);
  end;

  // Escala Global
  if (opt_projecao = 2) and (opt = 11) then
  begin
    aa := StrToFloat(GlobalEscalaEdit.Text);

    canvasCenterX := Image.Width div 2;
    canvasCenterY := Image.Height div 2;

      SetLength(MC, 1, 4);
      SetLength(MH, 4, 4);

      for a := 0 to 3 do
      begin
        for b := 0 to 3 do
        begin
          MH[a,b] := 0;
        end;
      end;
      MH[0,0] := 1 / aa;
      MH[1,1] := 1 / aa;
      MH[2,2] := 1 / aa;
      MH[3,3] := 1;

    LimparCanvas;
    opt := 11;

    ProjecaoOrtografica(MC, MH, canvasCenterX, canvasCenterY);

  end;

  // Translação
  if (opt_projecao = 3) and (opt = 11) then
  begin
    aa := StrToFloat(XTransEdit.Text);
    bb := StrToFloat(YTransEdit.Text);
    cc := StrToFloat(ZTransEdit.Text);

    canvasCenterX := Image.Width div 2;
    canvasCenterY := Image.Height div 2;


      SetLength(MC, 1, 4);
      SetLength(MH, 4, 4);
      for a := 0 to 3 do
      begin
        for b := 0 to 3 do
        begin
          MH[a,b] := 0;
        end;
      end;
      MH[0,0] := 1;
      MH[1,1] := 1;
      MH[2,2] := 1;
      MH[3,3] := 1;
      MH[3,0] := aa;
      MH[3,1] := bb;
      MH[3,2] := cc;

      LimparCanvas;
      opt := 11;

      ProjecaoOrtografica(MC, MH, canvasCenterX, canvasCenterY);
    end;

  // Rotação em torno eixos na origem
  if (opt_projecao = 4) and (opt = 11) then
  begin

    LimparCanvas;
    opt := 11;
    aa := StrToFloat(GrausEdit.Text) * Pi / 180;

    canvasCenterX := Image.Width div 2;
    canvasCenterY := Image.Height div 2;

    begin
      SetLength(MC, 1, 4);
      SetLength(MH, 4, 4);
      SetLength(MHO, 4, 4);
      SetLength(MResultado, 1, 4);
      SetLength(MResultadoO, 1, 4);
      for a := 0 to 3 do
      begin
        for b := 0 to 3 do
        begin
          MH[a,b] := 0;
          MHO[a,b] := 0;
        end;
      end;
      MH[0,0] := 1;
      MH[1,1] := 1;
      MH[2,2] := 1;
      MH[3,3] := 1;

      MHO[0,0] := 1;
      MHO[1,1] := 1;
      MHO[2,2] := 1;
      MHO[3,3] := 1;
      if (EixoEdit.Text = 'X') or (EixoEdit.Text = 'x') then
      begin
        MHO[1,1] := cos(aa);
        MHO[1,2] := sin(aa);
        MHO[2,1] := -sin(aa);
        MHO[2,2] := cos(aa);
      end;

      if (EixoEdit.Text = 'Y') or (EixoEdit.Text = 'y') then
      begin
        MHO[0,0] := cos(aa);
        MHO[0,2] := -sin(aa);
        MHO[2,0] := sin(aa);
        MHO[2,2] := cos(aa);
      end;

      if (EixoEdit.Text = 'Z') or (EixoEdit.Text = 'z') then
      begin
        MHO[0,0] := cos(aa);
        MHO[0,1] := sin(aa);
        MHO[1,0] := -sin(aa);
        MHO[1,1] := cos(aa);
      end;

      //Parte baixo (0,0,0)-(100,0,0)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,0] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (100,0,0)-(100,0,100)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (0,0,100)-(100,0,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,0] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (0,0,0)-(0,0,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (0,0,0)-(0,100,0)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (0,0,100)-(0,100,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (100,0,0)-(100,100,0)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (100,0,100)-(100,100,100)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (0,100,0)-(0,100,100)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (100,100,0)-(100,100,100)
      MC[0,0] := 100;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (50,150,0)-(50,150,100)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (0,100,0)-(50,150,0)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := a;
        MC[0,1] := 100 + a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (0,100,100)-(50,150,100)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := a;
        MC[0,1] := 100 + a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (50,150,0)-(100,100,0)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := 50 + a;
        MC[0,1] := 150 - a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (50,150,100)-(100,100,100)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := 50 + a;
        MC[0,1] := 150 - a;
        for b := 0 to 3 do
        begin
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHO, MResultadoO);
        MultiplicarMatrizes(MResultadoO, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      end;
    end;

  // Rotação em torno eixos no centro objeto
  if (opt_projecao = 5) and (opt = 11) then
  begin
    LimparCanvas;
    opt := 11;

    cx := 50;
    cy := 70;
    cz := 50;
    aa := StrToFloat(GrausEdit.Text) * Pi / 180;

    canvasCenterX := Image.Width div 2;
    canvasCenterY := Image.Height div 2;

    begin
      SetLength(MC, 1, 4);
      SetLength(MH, 4, 4);
      SetLength(MHO, 4, 4);
      SetLength(MHTPos, 4, 4);
      SetLength(MHTNeg, 4, 4);
      SetLength(MResultado, 1, 4);
      SetLength(MResultadoO, 1, 4);
      SetLength(MResultadoT, 1, 4);
      for a := 0 to 3 do
      begin
        for b := 0 to 3 do
        begin
          MH[a,b] := 0;
          MHO[a,b] := 0;
          MHTPos[a,b] := 0;
          MHTNeg[a,b] := 0;
        end;
      end;
      MH[0,0] := 1;
      MH[1,1] := 1;
      MH[2,2] := 1;
      MH[3,3] := 1;

      MHO[0,0] := 1;
      MHO[1,1] := 1;
      MHO[2,2] := 1;
      MHO[3,3] := 1;

      MHTPos[0,0] := 1;
      MHTPos[1,1] := 1;
      MHTPos[2,2] := 1;
      MHTPos[3,3] := 1;

      MHTNeg[0,0] := 1;
      MHTNeg[1,1] := 1;
      MHTNeg[2,2] := 1;
      MHTNeg[3,3] := 1;

      if (EixoEdit.Text = 'X') or (EixoEdit.Text = 'x') then
      begin
        MHO[1,1] := cos(aa);
        MHO[1,2] := sin(aa);
        MHO[2,1] := -sin(aa);
        MHO[2,2] := cos(aa);
      end;

      if (EixoEdit.Text = 'Y') or (EixoEdit.Text = 'y') then
      begin
        MHO[0,0] := cos(aa);
        MHO[0,2] := -sin(aa);
        MHO[2,0] := sin(aa);
        MHO[2,2] := cos(aa);
      end;

      if (EixoEdit.Text = 'Z') or (EixoEdit.Text = 'z') then
      begin
        MHO[0,0] := cos(aa);
        MHO[0,1] := sin(aa);
        MHO[1,0] := -sin(aa);
        MHO[1,1] := cos(aa);
      end;

      MHTPos[3,0] := cx;
      MHTPos[3,1] := cy;
      MHTPos[3,2] := cz;

      MHTNeg[3,0] := -cx;
      MHTNeg[3,1] := -cy;
      MHTNeg[3,2] := -cz;

      //Parte baixo (0,0,0)-(100,0,0)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,0] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;
        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (100,0,0)-(100,0,100)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (0,0,100)-(100,0,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,0] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (0,0,0)-(0,0,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (0,0,0)-(0,100,0)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (0,0,100)-(0,100,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (100,0,0)-(100,100,0)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (100,0,100)-(100,100,100)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (0,100,0)-(0,100,100)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (100,100,0)-(100,100,100)
      MC[0,0] := 100;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (50,150,0)-(50,150,100)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (0,100,0)-(50,150,0)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := a;
        MC[0,1] := 100 + a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (0,100,100)-(50,150,100)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := a;
        MC[0,1] := 100 + a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (50,150,0)-(100,100,0)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := 50 + a;
        MC[0,1] := 150 - a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (50,150,100)-(100,100,100)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := 50 + a;
        MC[0,1] := 150 - a;
        for b := 0 to 3 do
        begin
          MResultadoT[0,b] := 0;
          MResultadoO[0,b] := 0;
          MResultado[0,b] := 0;

        end;
        MultiplicarMatrizes(MC, MHTNeg, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MHO, MResultadoO);
        for b := 0 to 3 do
        begin
            MResultadoT[0,b] := 0;
        end;
        MultiplicarMatrizes(MResultadoO, MHTPos, MResultadoT);
        MultiplicarMatrizes(MResultadoT, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      end;
    end;

  // Shearing
  if (opt_projecao = 6) and (opt = 11) then
  begin
    LimparCanvas;
    opt := 11;

    aa := StrToFloat(Sh1.Text);
    bb := StrToFloat(Sh2.Text);
    cc := StrToFloat(Sh3.Text);
    dd := StrToFloat(Sh4.Text);
    ee := StrToFloat(Sh5.Text);
    ff := StrToFloat(Sh6.Text);
    gg := StrToFloat(Sh7.Text);
    hh := StrToFloat(Sh8.Text);
    ii := StrToFloat(Sh9.Text);
    jj := StrToFloat(Sh10.Text);
    kk := StrToFloat(Sh11.Text);
    ll := StrToFloat(Sh12.Text);
    mm := StrToFloat(Sh13.Text);
    nn := StrToFloat(Sh14.Text);
    oo := StrToFloat(Sh15.Text);
    pp := StrToFloat(Sh16.Text);

    canvasCenterX := Image.Width div 2;
    canvasCenterY := Image.Height div 2;

    SetLength(MC, 1, 4);
    SetLength(MH, 4, 4);
    for a := 0 to 3 do
    begin
         for b := 0 to 3 do
         begin
              MH[a,b] := 0;
         end;
    end;
    MH[0,0] := 1 * aa;
    MH[0,1] := 1 * bb;
    MH[0,2] := 1 * cc;
    MH[0,3] := 1 * dd;

    MH[1,0] := 1 * ee;
    MH[1,1] := 1 * ff;
    MH[1,2] := 1 * gg;
    MH[1,3] := 1 * hh;

    MH[2,0] := 1 * ii;
    MH[2,1] := 1 * jj;
    MH[2,2] := 1 * kk;
    MH[2,3] := 1 * ll;

    MH[3,0] := 1 * mm;
    MH[3,1] := 1 * nn;
    MH[3,2] := 1 * oo;
    MH[3,3] := 1 / pp;


    ProjecaoOrtografica(MC, MH, canvasCenterX, canvasCenterY);
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.ProjecaoOrtografica(const MC, MH: TMatriz; const canvasCenterX, CanvasCenterY: Integer);
var a, b, c: Integer;
var MResultado: TMatriz;
begin
      SetLength(MResultado, 1, 4);
      //Parte baixo (0,0,0)-(100,0,0)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,0] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (100,0,0)-(100,0,100)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (0,0,100)-(100,0,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,0] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte baixo (0,0,0)-(0,0,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (0,0,0)-(0,100,0)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (0,0,100)-(0,100,100)
      MC[0,0] := 0;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (100,0,0)-(100,100,0)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte vertical (100,0,100)-(100,100,100)
      MC[0,0] := 100;
      MC[0,1] := 0;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,1] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (0,100,0)-(0,100,100)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (100,100,0)-(100,100,100)
      MC[0,0] := 100;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior (50,150,0)-(50,150,100)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 100 do
      begin
        MC[0,2] := a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (0,100,0)-(50,150,0)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := a;
        MC[0,1] := 100 + a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (0,100,100)-(50,150,100)
      MC[0,0] := 0;
      MC[0,1] := 100;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := a;
        MC[0,1] := 100 + a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (50,150,0)-(100,100,0)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 0;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := 50 + a;
        MC[0,1] := 150 - a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

      //Parte superior diagonal (50,150,100)-(100,100,100)
      MC[0,0] := 50;
      MC[0,1] := 150;
      MC[0,2] := 100;
      MC[0,3] := 1;
      for a := 0 to 50 do
      begin
        MC[0,0] := 50 + a;
        MC[0,1] := 150 - a;
        MultiplicarMatrizes(MC, MH, MResultado);
        Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
      end;

end;

procedure TForm1.GlobalRadioButtonChange(Sender: TObject);
begin
  opt_projecao := 2;
end;

procedure TForm1.LocalRadioButtonChange(Sender: TObject);
begin
  opt_projecao := 1;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
var
  a, aa, b, c : Integer;
  MC, MH, MResultado : array of array of Double;
  canvasCenterX, canvasCenterY : Integer;
begin
  canvasCenterX := Image.Width div 2;
  canvasCenterY := Image.Height div 2;

  opt := 11;
  begin
    SetLength(MC, 1, 4);
    SetLength(MH, 4, 4);
    SetLength(MResultado, 1, 4);
    for a := 0 to 3 do
    begin
      for b := 0 to 3 do
      begin
        MH[a,b] := 0;
      end;
    end;
    MH[0,0] := 1;
    MH[1,1] := 1;
    MH[3,3] := 1;

    //Parte baixo (0,0,0)-(100,0,0)
    MC[0,0] := 0;
    MC[0,1] := 0;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,0] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte baixo (100,0,0)-(100,0,100)
    MC[0,0] := 100;
    MC[0,1] := 0;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,2] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte baixo (0,0,100)-(100,0,100)
    MC[0,0] := 0;
    MC[0,1] := 0;
    MC[0,2] := 100;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,0] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte baixo (0,0,0)-(0,0,100)
    MC[0,0] := 0;
    MC[0,1] := 0;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,2] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte vertical (0,0,0)-(0,100,0)
    MC[0,0] := 0;
    MC[0,1] := 0;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,1] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte vertical (0,0,100)-(0,100,100)
    MC[0,0] := 0;
    MC[0,1] := 0;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,1] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte vertical (100,0,0)-(100,100,0)
    MC[0,0] := 100;
    MC[0,1] := 0;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,1] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte vertical (100,0,100)-(100,100,100)
    MC[0,0] := 100;
    MC[0,1] := 0;
    MC[0,2] := 100;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,1] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte superior (0,100,0)-(0,100,100)
    MC[0,0] := 0;
    MC[0,1] := 100;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,2] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte superior (100,100,0)-(100,100,100)
    MC[0,0] := 100;
    MC[0,1] := 100;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,2] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte superior (50,150,0)-(50,150,100)
    MC[0,0] := 50;
    MC[0,1] := 150;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 100 do
    begin
      MC[0,2] := a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte superior diagonal (0,100,0)-(50,150,0)
    MC[0,0] := 0;
    MC[0,1] := 100;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 50 do
    begin
      MC[0,0] := a;
      MC[0,1] := 100 + a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte superior diagonal (0,100,100)-(50,150,100)
    MC[0,0] := 0;
    MC[0,1] := 100;
    MC[0,2] := 100;
    MC[0,3] := 1;
    for a := 0 to 50 do
    begin
      MC[0,0] := a;
      MC[0,1] := 100 + a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte superior diagonal (50,150,0)-(100,100,0)
    MC[0,0] := 50;
    MC[0,1] := 150;
    MC[0,2] := 0;
    MC[0,3] := 1;
    for a := 0 to 50 do
    begin
      MC[0,0] := 50 + a;
      MC[0,1] := 150 - a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

    //Parte superior diagonal (50,150,100)-(100,100,100)
    MC[0,0] := 50;
    MC[0,1] := 150;
    MC[0,2] := 100;
    MC[0,3] := 1;
    for a := 0 to 50 do
    begin
      MC[0,0] := 50 + a;
      MC[0,1] := 150 - a;
      MultiplicarMatrizes(MC, MH, MResultado);
      Image.Canvas.Pixels[canvasCenterX + Round(MResultado[0,0]), canvasCenterY - Round(MResultado[0,1])] := clred;
    end;

  end;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  opt := 12;
  LimparCanvas;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
  opt := 13;
end;

procedure TForm1.MenuItem15Click(Sender: TObject);
var
  mySphere: Sphere;
  myPlane: Plane;
  lightSource: Light;
  ALight: AmbientLight;
  observer: Point3D;
  size: Double;
begin
  // Initialize the sphere
  mySphere.Center.x := 0;
  mySphere.Center.y := 0;
  mySphere.Center.z := 0;
  mySphere.Radius := 50;

  mySphere.Mat.Kd := 0.3;
  mySphere.Mat.Ks := 0.8;
  mySphere.Mat.Color := clYellow;

  // Initialize the plane
  size := 100;
  myPlane.Origin.x := -size/2;
  myPlane.Origin.y := -size/2;
  myPlane.Origin.z := 0;

  myPlane.U.x := size;
  myPlane.U.y := 0;
  myPlane.U.z := 0;

  myPlane.V.x := 0;
  myPlane.V.y := size;
  myPlane.V.z := 0;

  myPlane.Mat.Kd := 0.7;
  myPlane.Mat.Ks := 0.7;
  myPlane.Mat.Color := clRed;

  // Observer
  observer.x := 0;
  observer.y := 0;
  observer.z := 100;

  // Light Source
  lightSource.Pos.x := 100;
  lightSource.Pos.y := 0;
  lightSource.Pos.z := 100;

  lightSource.I.x := 0.7;
  lightSource.I.y := 0.7;
  lightSource.I.z := 0.7;

  //Ambient Light
  ALight.I.x := 0.7;
  ALight.I.y := 0.7;
  ALight.I.z := 0.7;

  ALight.K.x := 0.2;
  ALight.K.y := 0.2;
  ALight.K.z := 0.2;
end;

procedure TForm1.RotCentroButtonChange(Sender: TObject);
begin
  opt_projecao := 5;
end;

procedure TForm1.RotOrigemButtonChange(Sender: TObject);
begin
  opt_projecao := 4;
end;

procedure TForm1.ShRadioButtonChange(Sender: TObject);
begin
  opt_projecao := 6;
end;

procedure TForm1.TransRadioButtonChange(Sender: TObject);
begin
  opt_projecao := 3;
end;

procedure TForm1.XEscalaEditChange(Sender: TObject);
begin

end;

procedure TForm1.imageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  newLine: Line;
begin
  if(opt = 1) then
  begin
    desenhar := true;
    image.Canvas.Pixels[X, Y] := clred;
  end;

  if((opt = 2) or (opt = 3) or (opt = 4) or (opt = 5) or (opt = 6) or (opt = 7) or (opt = 13) or (opt = 14)) then
  begin
    p1.X := X;
    p1.Y := Y;
  end;

  if (opt = 8) then
  begin
      floodFill4(X, Y, clred, clblack);
  end;

  if (opt = 9) then
  begin
      floodFill8(X, Y, clred, clblack);
  end;

  if (opt = 10) then
begin
  if hasPrevious then
  begin
    // Criar nova reta

    newLine.p1 := previousPoint;
    newLine.p2 := Point(X, Y);

    lineBresenham(newLine.p1, newLine.p2);

    // Inserir no polígono
    SetLength(poly.edges, Length(poly.edges) + 1);
    poly.edges[High(poly.edges)] := newLine;
  end;

  // Atualiza ponto anterior
  previousPoint := Point(X, Y);
  hasPrevious := True;
end;
end;

procedure TForm1.imageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
     if (opt = 1) and (desenhar = true) then
     begin
       image.Canvas.Pixels[X, Y] := clred;
     end;
end;

function ComputeOutCode(x, y, xmin, ymin, xmax, ymax: Integer): Integer;
begin
  Result := INSIDE;
  if x < xmin then Result := Result or LEFT
  else if x > xmax then Result := Result or RIGHT;
  if y < ymin then Result := Result or BOTTOM
  else if y > ymax then Result := Result or TOP;
end;

function CohenSutherlandClip(var x0, y0, x1, y1: Integer;
                             xmin, ymin, xmax, ymax: Integer): Boolean;
var
  outcode0, outcode1, outcodeOut: Integer;
  accept: Boolean;
  x, y: Double;
begin
  outcode0 := ComputeOutCode(x0, y0, xmin, ymin, xmax, ymax);
  outcode1 := ComputeOutCode(x1, y1, xmin, ymin, xmax, ymax);
  accept := False;

  while True do
  begin
    if (outcode0 or outcode1) = 0 then
    begin
      accept := True;
      Break;
    end
    else if (outcode0 and outcode1) <> 0 then
    begin
      Break;
    end
    else
    begin
      if outcode0 <> 0 then
        outcodeOut := outcode0
      else
        outcodeOut := outcode1;

      if (outcodeOut and TOP) <> 0 then
      begin
        x := x0 + (x1 - x0) * (ymax - y0) / (y1 - y0);
        y := ymax;
      end
      else if (outcodeOut and BOTTOM) <> 0 then
      begin
        x := x0 + (x1 - x0) * (ymin - y0) / (y1 - y0);
        y := ymin;
      end
      else if (outcodeOut and RIGHT) <> 0 then
      begin
        y := y0 + (y1 - y0) * (xmax - x0) / (x1 - x0);
        x := xmax;
      end
      else if (outcodeOut and LEFT) <> 0 then
      begin
        y := y0 + (y1 - y0) * (xmin - x0) / (x1 - x0);
        x := xmin;
      end;

      if outcodeOut = outcode0 then
      begin
        x0 := Round(x);
        y0 := Round(y);
        outcode0 := ComputeOutCode(x0, y0, xmin, ymin, xmax, ymax);
      end
      else
      begin
        x1 := Round(x);
        y1 := Round(y);
        outcode1 := ComputeOutCode(x1, y1, xmin, ymin, xmax, ymax);
      end;
    end;
  end;

  Result := accept;
end;

procedure TForm1.lineBresenham(p1, p2: TPoint);
var
  raio, xp, yp, a, m, dx, dy, t, d, sx, sy: Double;
  xi, yi, xn, i: Integer;
begin
     dx := Abs(p2.X - p1.X);
     dy := Abs(p2.Y - p1.Y);

    if (p1.X < p2.X) then sx := 1 else sx := -1;
    if (p1.Y < p2.Y) then sy := 1 else sy := -1;

    xp := p1.X;
    yp := p1.Y;

    image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;

    if (dx > dy) then
    begin
      // Caminha em X
      d := 2 * dy - dx;
      while (xp <> p2.X) do
      begin
        xp := xp + sx;
        if (d < 0) then
          d := d + 2 * dy
        else
        begin
          d := d + 2 * (dy - dx);
          yp := yp + sy;
        end;
        image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;
      end;
    end
    else
    begin
      // Caminha em Y
      d := 2 * dx - dy;
      while (yp <> p2.Y) do
      begin
           yp := yp + sy;
           if (d < 0) then
              d := d + 2 * dx
           else
           begin
                d := d + 2 * (dx - dy);
                xp := xp + sx;
           end;
      image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;
      end;
    end;
end;

procedure TForm1.imageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  raio, xp, yp, a, m, dx, dy, t, d, sx, sy: Double;
  xi, yi, xn, i, n: Integer;
  cos1, sen1: Double;
begin
  if (opt = 1) then
    desenhar := False;

  // Linhas geral
  if (opt = 2) then
  begin
    p2.X := X;
    p2.Y := Y;

    dx := Abs(p2.X - p1.X);
    dy := Abs(p2.Y - p1.Y);

    if dx >= dy then
    begin
      // percorre em X
      if p1.X <= p2.X then
      begin
        xp := p1.X;
        while xp <= p2.X do
        begin
          m := (p2.Y - p1.Y) /(p2.X - p1.X);

          yp := m * (xp - p1.X) + p1.Y;
          image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;
          xp := xp + 1;
        end;
      end
      else
      begin
        xp := p2.X;
        while xp <= p1.X do
        begin
          m := (p1.Y - p2.Y) /(p1.X - p2.X);

          yp := m * (xp - p2.X) + p2.Y;
          image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;
          xp := xp + 1;
        end;
      end;
    end
    else
    begin
      // percorre em Y
      if p1.Y <= p2.Y then
      begin
        yp := p1.Y;
        while yp <= p2.Y do
        begin
          m := (p2.Y - p1.Y) /(p2.X - p1.X);

          xp := (yp - p1.Y) / m + p1.X;
          image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;
          yp := yp + 1;
        end;
      end
      else
      begin
        yp := p2.Y;
        while yp <= p1.Y do
        begin
          m := (p1.Y - p2.Y) /(p1.X - p2.X);

          xp := (yp - p2.Y) / m + p2.X;
          image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;
          yp := yp + 1;
        end;
      end;
    end;
  end;

  // Linhas parametrica
  if (opt = 3) then
  begin
    p2.X := X;
    p2.Y := Y;
    t := 0;

    while t <= 1 do
    begin
      xp := p1.X + (p2.X - p1.X) * t;
      yp := p1.Y + (p2.Y - p1.Y) * t;

      image.Canvas.Pixels[Round(xp), Round(yp)] := clRed;

      t := t + 0.001;
    end;
  end;

  // Linhas Bresenham
  if (opt = 7) then
  begin
       p2.X := X;
       p2.Y := Y;
       lineBresenham(p1, p2);
  end;


  if (opt = 4) then
  begin
    p2.X := X;
    p2.Y := Y;

    raio := Sqrt(Sqr(p1.X - p2.X) + Sqr(p1.Y - p2.Y));

    xp := -raio;
    while (xp <= raio) do
    begin
      yp := Sqrt(raio * raio - xp * xp);

      xi := Round(xp);
      yi := Round(yp);

      image.Canvas.Pixels[p1.X + xi, p1.Y + yi] := clRed;
      image.Canvas.Pixels[p1.X + xi, p1.Y - yi] := clRed;

      xp := xp + 0.001;
    end;
  end;

  if (opt = 5) then
  begin
    p2.X := X;
    p2.Y := Y;

    raio := Sqrt(Sqr(p1.X - p2.X) + Sqr(p1.Y - p2.Y));

    a := 0;
    while (a < 6.28) do
    begin
      xi := Round(raio * cos(a));
      yi := Round(raio * sin(a));

      image.Canvas.Pixels[p1.X + xi, p1.Y + yi] := clRed;
      image.Canvas.Pixels[p1.X + xi, p1.Y - yi] := clRed;

      a := a + 0.01;
    end;
  end;

  if (opt = 6) then
  begin
    p2.X := X;
    p2.Y := Y;

    raio := Sqrt(Sqr(p1.X - p2.X) + Sqr(p1.Y - p2.Y));

    xi := Round(raio);
    yi := 0;

    cos1 := cos(1);
    sen1 := sin(1);
    for i:=1 to 360 do
    begin
      xn := Round(xi*cos1 - yi*sen1);
      yi := Round(xi*sen1 +  yi*cos1);
      xi := xn;

      image.Canvas.Pixels[p1.X + xi, p1.Y + yi] := clRed;
      image.Canvas.Pixels[p1.X + xi, p1.Y - yi] := clRed;
    end;
  end;

  if(opt = 13) then
  begin
    LimparCanvas;
    p2.X := X;
    p2.Y := Y;

    xmin := MinInt(p1.X, p2.X);
    xmax := MaxInt(p1.X, p2.X);
    ymin := MinInt(p1.Y, p2.Y);
    ymax := MaxInt(p1.Y, p2.Y);

    // desenha retângulo
    for n:= xmin to xmax do
    begin
      Image.Canvas.Pixels[n, ymin] := clRed;
      Image.Canvas.Pixels[n, ymax] := clRed;
    end;

    for n:= ymin to ymax do
    begin
      Image.Canvas.Pixels[xmin, n] := clRed;
      Image.Canvas.Pixels[xmax, n] := clRed;
    end;

    opt := 14;
  end
  else if(opt = 14) then
  begin
    p2.X := X;
    p2.Y := Y;

    // Aplica clipping
    if CohenSutherlandClip(p1.X, p1.Y, p2.X, p2.Y, xmin, ymin, xmax, ymax) then
      lineBresenham(p1, p2);  // só desenha se a linha (ou parte dela) estiver dentro
  end;
end;

function MinInt(a, b: Integer): Integer;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

function MaxInt(a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

procedure TForm1.DesenharCirculoClick(Sender: TObject);
begin
     opt := 4;
end;

procedure TForm1.CirculoParametricoClick(Sender: TObject);
begin
     opt := 5;
end;

procedure TForm1.FloodFill4Click(Sender: TObject);
begin
     opt := 8;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
     opt := 2;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
     opt := 7;
end;

procedure TForm1.FloodFill8Click(Sender: TObject);
begin
     opt := 9;
end;

procedure TForm1.DesenharPoligonoClick(Sender: TObject);
begin
     opt := 10;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
var
  newLine: Line;
begin
  if hasPrevious and (Length(poly.edges) > 0) then
  begin
    // Close polygon: connect last point to the first point from edges
    newLine.p1 := previousPoint;
    newLine.p2 := poly.edges[0].p1;

    lineBresenham(newLine.p1, newLine.p2);

    // Insert closing edge
    SetLength(poly.edges, Length(poly.edges) + 1);
    poly.edges[High(poly.edges)] := newLine;

    hasPrevious := False;
  end;
end;

procedure TForm1.InvertPixel(x, y: Integer);
var
  c: TColor;
begin
  c := image.Canvas.Pixels[x, y];
  if c = clBlack then
    image.Canvas.Pixels[x, y] := clRed
  else
    image.Canvas.Pixels[x, y] := clBlack;
end;


procedure TForm1.MenuItem11Click(Sender: TObject);
type
  TEdge = record
    ymax: Integer;
    x: Double;
    invSlope: Double;
  end;
var
  y, i, j: Integer;
  ymin, ymaxPoly: Integer;
  AET: array of TEdge;       // Active Edge Table
  newAET: array of TEdge;    // Temporário para atualização
  tempEdge, polyEdge: TEdge;
  e: Line;
  n, m: Integer;
begin
  if Length(poly.edges) = 0 then Exit;

  // 1) calcula ymin e ymax do polígono
  ymin := poly.edges[0].p1.Y;
  ymaxPoly := poly.edges[0].p1.Y;
  for i := 0 to High(poly.edges) do
  begin
    e := poly.edges[i];
    if e.p1.Y < ymin then ymin := e.p1.Y;
    if e.p2.Y < ymin then ymin := e.p2.Y;
    if e.p1.Y > ymaxPoly then ymaxPoly := e.p1.Y;
    if e.p2.Y > ymaxPoly then ymaxPoly := e.p2.Y;
  end;

  // 2) inicializa Active Edge Table vazia
  SetLength(AET, 0);

  // 3) percorre cada scanline
  for y := ymin to ymaxPoly do
  begin
    // Adiciona arestas que começam na linha y
    for i := 0 to High(poly.edges) do
    begin
      e := poly.edges[i];

      if e.p1.Y = e.p2.Y then Continue; // ignora horizontais

      if (e.p1.Y = y) or (e.p2.Y = y) then
      begin
        if e.p1.Y < e.p2.Y then
        begin
          tempEdge.ymax := e.p2.Y;
          tempEdge.x := e.p1.X;
          tempEdge.invSlope := (e.p2.X - e.p1.X) / (e.p2.Y - e.p1.Y);
        end
        else
        begin
          tempEdge.ymax := e.p1.Y;
          tempEdge.x := e.p2.X;
          tempEdge.invSlope := (e.p1.X - e.p2.X) / (e.p1.Y - e.p2.Y);
        end;

        SetLength(AET, Length(AET)+1);
        AET[High(AET)] := tempEdge;
      end;
    end;

    // Remove arestas cujo ymax = y
    n := 0;
    SetLength(newAET, 0);
    for i := 0 to High(AET) do
      if AET[i].ymax > y then
      begin
        SetLength(newAET, n+1);
        newAET[n] := AET[i];
        Inc(n);
      end;
    AET := newAET;

    // Ordena AET por x
    for i := 0 to Length(AET)-2 do
      for j := i+1 to Length(AET)-1 do
        if AET[i].x > AET[j].x then
        begin
          tempEdge := AET[i];
          AET[i] := AET[j];
          AET[j] := tempEdge;
        end;

    // Preenche/inverte pixels entre pares de interseções
    i := 0;
    while i < Length(AET)-1 do
    begin
      for j := Round(AET[i].x) to Round(AET[i+1].x) do
        InvertPixel(j, y);
      Inc(i, 2);
    end;

    // Atualiza X das arestas na AET
    for i := 0 to High(AET) do
      AET[i].x := AET[i].x + AET[i].invSlope;
  end;
end;


procedure TForm1.operacoesMenuClick(Sender: TObject);
begin
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  opt := 3;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
end;

procedure TForm1.floodFill4(x, y : Integer; cor, borda : TColor);
var bmp: TBitmap;
begin
  bmp := image.Picture.Bitmap;
  if (bmp = nil) then Exit;
  if (x < 0) or (y < 0) or (x >= bmp.Width) or (y >= bmp.Height) then Exit;
  if (bmp.Canvas.Pixels[x,y] = borda) or (bmp.Canvas.Pixels[x,y] = cor) then Exit;

  bmp.Canvas.Pixels[x,y] := cor;

  if x+1 < bmp.Width then floodFill4(x+1, y, cor, borda);
  if x-1 >= 0 then floodFill4(x-1, y, cor, borda);
  if y+1 < bmp.Height then floodFill4(x, y+1, cor, borda);
  if y-1 >= 0 then floodFill4(x, y-1, cor, borda);
end;

procedure TForm1.floodFill8(x, y: Integer; cor, borda: TColor);
var
  bmp: TBitmap;
begin
  bmp := image.Picture.Bitmap;
  if (bmp = nil) then Exit;
  if (x < 0) or (y < 0) or (x >= bmp.Width) or (y >= bmp.Height) then Exit;
  if (bmp.Canvas.Pixels[x,y] = borda) or (bmp.Canvas.Pixels[x,y] = cor) then Exit;

  bmp.Canvas.Pixels[x,y] := cor;

  // 4 direções principais
  floodFill8(x+1, y, cor, borda);
  floodFill8(x-1, y, cor, borda);
  floodFill8(x, y+1, cor, borda);
  floodFill8(x, y-1, cor, borda);

  // 4 diagonais
  floodFill8(x+1, y+1, cor, borda);
  floodFill8(x+1, y-1, cor, borda);
  floodFill8(x-1, y+1, cor, borda);
  floodFill8(x-1, y-1, cor, borda);
end;

procedure TForm1.LimparCanvas;
begin
  Image.Canvas.Brush.Color := clBlack;
  Image.Canvas.FillRect(0, 0, Image.Width, Image.Height);
end;

procedure TForm1.fillPolygon(p: Polygon);
begin

end;

function TForm1.VectorSubtract(const A, B: Point3D): Point3D;
begin
  Result.x := A.x - B.x;
  Result.y := A.y - B.y;
  Result.z := A.z - B.z;
end;

function TForm1.VectorAdd(const A, B: Point3D): Point3D;
begin
  Result.x := A.x + B.x;
  Result.y := A.y + B.y;
  Result.z := A.z + B.z;
end;

function TForm1.VectorScale(const V: Point3D; S: Double): Point3D;
begin
  Result.x := V.x * S;
  Result.y := V.y * S;
  Result.z := V.z * S;
end;

function TForm1.VectorLength(const V: Point3D): Double;
begin
  Result := Sqrt(V.x*V.x + V.y*V.y + V.z*V.z);
end;

function TForm1.VectorNormalize(const V: Point3D): Point3D;
var L: Double;
begin
  L := VectorLength(V);
  if L = 0 then L := 1;
  Result.x := V.x / L;
  Result.y := V.y / L;
  Result.z := V.z / L;
end;

function TForm1.Dot(const A, B: Point3D): Double;
begin
  Result := A.x*B.x + A.y*B.y + A.z*B.z;
end;

function TForm1.Reflect(const L, N: Point3D): Point3D;
var dotLN: Double;
begin
  dotLN := 2 * Dot(N, L);
  Result.x := dotLN*N.x - L.x;
  Result.y := dotLN*N.y - L.y;
  Result.z := dotLN*N.z - L.z;
end;


function TForm1.TransformPoint(const P: Point3D; const M: TMatrix4x4): Point3D;
var
  x, y, z, w: Double;
begin
  x := P.x * M[0,0] + P.y * M[0,1] + P.z * M[0,2] + M[0,3];
  y := P.x * M[1,0] + P.y * M[1,1] + P.z * M[1,2] + M[1,3];
  z := P.x * M[2,0] + P.y * M[2,1] + P.z * M[2,2] + M[2,3];
  w := P.x * M[3,0] + P.y * M[3,1] + P.z * M[3,2] + M[3,3];

  if w <> 0 then
  begin
    x := x / w;
    y := y / w;
    z := z / w;
  end;

  Result.x := x;
  Result.y := y;
  Result.z := z;
end;

procedure TForm1.ApplyTransformPlane(var P: Plane; const M: TMatrix4x4);
begin
  P.Origin := TransformPoint(P.Origin, M);
  P.U := TransformPoint(P.U, M);
  P.V := TransformPoint(P.V, M);
end;

procedure TForm1.ApplyTransformSphere(var S: Sphere; const M: TMatrix4x4);
var
  scaleX, scaleY, scaleZ: Double;
  newCenter: Point3D;
begin
  S.Center := TransformPoint(S.Center, M);

  scaleX := Sqrt(M[0,0]*M[0,0] + M[0,1]*M[0,1] + M[0,2]*M[0,2]);
  scaleY := Sqrt(M[1,0]*M[1,0] + M[1,1]*M[1,1] + M[1,2]*M[1,2]);
  scaleZ := Sqrt(M[2,0]*M[2,0] + M[2,1]*M[2,1] + M[2,2]*M[2,2]);

  S.Radius := S.Radius * ((scaleX + scaleY + scaleZ) / 3);
end;

function TForm1.Cross(const A, B: Point3D): Point3D;
begin
  Result.x := A.y * B.z - A.z * B.y;
  Result.y := A.z * B.x - A.x * B.z;
  Result.z := A.x * B.y - A.y * B.x;
end;

function TForm1.IlluminationModel1(
  const ambient: AmbientLight;
  const lights: TLightArray;
  const m: Material;
  const angle: Double
): TColor;
var
  ambientComponent, lightsComponent, finalComponent: Double;
  i: Integer;
  aux: Point3D;
  r, g, b: Byte;
begin
  // Ambient contribution (sum of RGB components as a fraction)
  ambientComponent := Dot(ambient.I, ambient.K);

  // Initialize lights contribution
  lightsComponent := 0;

  aux.x := m.Kd;
  aux.y := m.Kd;
  aux.z := m.Kd;

  for i := 0 to High(lights) do
    lightsComponent := lightsComponent + Dot(lights[i].I, aux) * Cos(angle);

  finalComponent := ambientComponent + lightsComponent;

  // Clamp final component to [0..1]
  if finalComponent > 1 then finalComponent := 1;

  // Extract RGB from m.Color and scale by finalComponent
  r := Round(Red(m.Color) * finalComponent);
  g := Round(Green(m.Color) * finalComponent);
  b := Round(Blue(m.Color) * finalComponent);

  // Clamp RGB to [0..255]
  if r > 255 then r := 255;
  if g > 255 then g := 255;
  if b > 255 then b := 255;

  Result := RGBToColor(r, g, b);
end;


end.
