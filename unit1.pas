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
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure operacoesMenuClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
  private
  public
    procedure floodFill4(x, y : Integer; cor, borda : TColor);
    procedure floodFill8(x, y : Integer; cor, borda : TColor);
    procedure fillPolygon(p : Polygon);
    procedure lineBresenham(p1, p2 : TPoint);
    procedure InvertPixel(x, y: Integer);
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

  if((opt = 2) or (opt = 3) or (opt = 4) or (opt = 5) or (opt = 6) or (opt = 7)) then
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

procedure TForm1.fillPolygon(p: Polygon);
begin

end;

end.
