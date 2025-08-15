unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    image: TImage;
    mainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem5: TMenuItem;
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
    procedure imageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure imageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DesenharCirculoClick(Sender: TObject);
    procedure CirculoParametricoClick(Sender: TObject);
    procedure operacoesMenuClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  opt: integer;
  desenhar: boolean;
  p1: TPoint;
  p2: TPoint;

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
end;

procedure TForm1.imageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
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

procedure TForm1.operacoesMenuClick(Sender: TObject);
begin

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin

end;

end.

