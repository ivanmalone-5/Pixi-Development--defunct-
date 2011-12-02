unit uDLLLoader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uDLLManager, Vcl.ComCtrls,
  Vcl.Menus;

type
  TfrmDLLLoader = class(TForm)
    ebFilename: TEdit;
    Label1: TLabel;
    ebHandle: TEdit;
    Label2: TLabel;
    btnLoad: TButton;
    btnUnload: TButton;
    btnFind: TButton;
    OpenDialog: TOpenDialog;
    DLLLoader: TDLLLoader;
    ListView: TListView;
    PopupMenu: TPopupMenu;
    miClear: TMenuItem;
    procedure btnFindClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnloadClick(Sender: TObject);
    procedure DLLLoaderDllAfterLoadEvent(Sender: TObject);
    procedure DLLLoaderDllAfterUnloadEvent(Sender: TObject);
    procedure DLLLoaderDllBeforeLoadEvent(Sender: TObject);
    procedure DLLLoaderDllBeforeUnloadEVent(Sender: TObject);
    procedure DLLLoaderLoadDllErrorEvent(Sender: TObject);
    procedure DLLLoaderUnloadDllErrorEvent(Sender: TObject);
    procedure miClearClick(Sender: TObject);
    procedure DLLLoaderStateChangedEvent(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    PROCEDURE AddToListview(aString : string);
  end;

var
  frmDLLLoader: TfrmDLLLoader;

implementation

{$R *.dfm}

procedure TfrmDLLLoader.btnFindClick(Sender: TObject);
begin
if OpenDialog.Execute then
   Begin
     if DLLLoader.Handle > 0 then
        Begin
          DLLLoader.UnloadDll;
        End;
     ebFileName.Text := OpenDialog.FileName;
     DLLLoader.Filename := OpenDialog.FileName;
     ebHandle.Text := '0';
   End;

end;

PROCEDURE TfrmDLLLoader.AddToListview(aString : string);
Var
  ListItem : TListItem;
Begin
ListItem := ListView.Items.Add;
ListItem.Caption := aString;

End;

procedure TfrmDLLLoader.btnLoadClick(Sender: TObject);
begin
DLLLoader.LoadDll;
ebHandle.Text := IntToStr(DLLLoader.Handle);
end;

procedure TfrmDLLLoader.btnUnloadClick(Sender: TObject);
begin
DLLLoader.UnloadDll;
ebHandle.Text := IntToStr(DLLLoader.Handle);
end;

procedure TfrmDLLLoader.DLLLoaderDllAfterLoadEvent(Sender: TObject);
begin
AddToListView('OnDLLAfterLoadEvent');
end;

procedure TfrmDLLLoader.DLLLoaderDllAfterUnloadEvent(Sender: TObject);
begin
AddToListView('0nDllAfterUnloadEvent');
end;

procedure TfrmDLLLoader.DLLLoaderDllBeforeLoadEvent(Sender: TObject);
begin
AddToListView('OnDllBeforeLoadEvent');
end;

procedure TfrmDLLLoader.DLLLoaderDllBeforeUnloadEVent(Sender: TObject);
begin
AddToListView('OnDllBeforeUnloadEvent');
end;

procedure TfrmDLLLoader.DLLLoaderLoadDllErrorEvent(Sender: TObject);
begin
AddToListView('LoadDllErrorEvent');
end;

procedure TfrmDLLLoader.DLLLoaderStateChangedEvent(Sender: TObject);
begin
ebFileName.Text := DLLLoader.Filename;
ebHandle.Text := IntToStr(DLLLoader.Handle);
end;

procedure TfrmDLLLoader.DLLLoaderUnloadDllErrorEvent(Sender: TObject);
begin
AddToListView('UnloadDllErrorEvent');
end;

procedure TfrmDLLLoader.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DLLLoader.UnloadDll;
end;

procedure TfrmDLLLoader.miClearClick(Sender: TObject);
begin
ListView.Clear;
end;

end.
