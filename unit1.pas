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
    MenuItem6: TMenuItem;
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
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
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

  if((opt = 2) or (opt = 3) or (opt = 4) or (opt = 5) or (opt = 6) or (opt = 7)) then
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
  raio, xp, yp, a, m, dx, dy, t, d, sx, sy: Double;
  xi, yi, xn, i: Integer;
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

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
     opt := 2;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
     opt := 7;
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

end.

