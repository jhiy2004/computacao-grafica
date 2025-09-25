unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  ExtDlgs;

TYPE
  Line = RECORD
    p1, p2 : TPoint;
  END;

  Polygon = RECORD
    edges : ARRAY OF Line;
  END;

type

  { TForm1 }

  TForm1 = class(TForm)
    image: TImage;
    mainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    pictureDialog: TOpenPictureDialog;
    operacoesMenu: TMenuItem;
    desenharMenuItem: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    arquivoMenu: TMenuItem;
    abrirArquivo: TMenuItem;
    procedure abrirArquivoClick(Sender: TObject);
    procedure CirculoGrausClick(Sender: TObject);
    procedure desenharMenuItemClick(Sender: TObject);
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
    procedure operacoesMenuClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
  private
  public
    procedure floodFill4(x, y : Integer; cor, borda : TColor);
    procedure floodFill8(x, y : Integer; cor, borda : TColor);
    procedure fillPolygon(p : Polygon);
  end;

var
  Form1: TForm1;
  opt: integer;
  desenhar: boolean;
  p1: TPoint;
  p2: TPoint;
  poly: Polygon;
  hasPrevious: Boolean = False;
  previousPoint: TPoint;

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

  if((opt = 4) or (opt = 5) or (opt = 6)) then
  begin
    p1.X := X;
    p1.Y := Y;
  end;

  if (opt = 7) then
  begin
      floodFill4(X, Y, clred, clblack);
  end;

  if (opt = 8) then
  begin
      floodFill8(X, Y, clred, clblack);
  end;

  if (opt = 9) then
begin
  if hasPrevious then
  begin
    // Criar nova reta

    newLine.p1 := previousPoint;
    newLine.p2 := Point(X, Y);

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

procedure TForm1.imageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  raio, xp, yp, a: Double;
  xi, yi, xn, i: Integer;
  cos1, sen1: Double;
begin
  if (opt = 1) then
    desenhar := False;

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
     opt := 7;
end;

procedure TForm1.FloodFill8Click(Sender: TObject);
begin
     opt := 8;
end;

procedure TForm1.DesenharPoligonoClick(Sender: TObject);
begin
     opt := 9;
end;

procedure TForm1.operacoesMenuClick(Sender: TObject);
begin
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
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

procedure TForm1.fillPolygon(p: Polygon);
begin

end;

end.
