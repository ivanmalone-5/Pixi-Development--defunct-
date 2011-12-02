unit uMultiDLLLoader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDLLLoader, Vcl.Menus, uDLLManager,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMultiDllLoader = class(TfrmDLLLoader)
    N1: TMenuItem;
    miFirst: TMenuItem;
    miBack: TMenuItem;
    miNext: TMenuItem;
    miLast: TMenuItem;
    N2: TMenuItem;
    miLoadAll: TMenuItem;
    miUnloadAll: TMenuItem;
    MultiDLLLoader: TMultiDLLLoader;
    procedure btnFindClick(Sender: TObject);
    procedure MultiDLLLoaderNavigateEvent(Sender: TObject);
    procedure miFirstClick(Sender: TObject);
    procedure miBackClick(Sender: TObject);
    procedure miNextClick(Sender: TObject);
    procedure miLastClick(Sender: TObject);
    procedure miLoadAllClick(Sender: TObject);
    procedure miUnloadAllClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnUnloadClick(Sender: TObject);
    procedure MultiDLLLoaderAfterAddEvent(Sender: TObject);
    procedure MultiDLLLoaderAfterLoadAllEvent(Sender: TObject);
    procedure MultiDLLLoaderAfterUnloadALllEvent(Sender: TObject);
    procedure MultiDLLLoaderArrayNotInSyncError(Sender: TObject);
    procedure MultiDLLLoaderBeforeAddEvent(Sender: TObject);
    procedure MultiDLLLoaderBeforeLoadAllEvent(Sender: TObject);
    procedure MultiDLLLoaderBeforeUnloadAllEvent(Sender: TObject);
    procedure MultiDLLLoaderClearEvent(Sender: TObject);
    procedure MultiDLLLoaderStateChangedEvent(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMultiDllLoader: TfrmMultiDllLoader;

implementation

{$R *.dfm}

procedure TfrmMultiDllLoader.btnFindClick(Sender: TObject);
begin
//  inherited;
if OpenDialog.Execute then
Begin
  MultiDllLoader.Add(OpenDialog.FileName);
  ebFileName.Text := MultiDLLLoader.Filename;
End;

end;

procedure TfrmMultiDllLoader.btnLoadClick(Sender: TObject);
begin
//  inherited;
ebHandle.Text := IntToStr(MultiDllLoader.LoadDll);
end;

procedure TfrmMultiDllLoader.btnUnloadClick(Sender: TObject);
begin
//  inherited;
MultiDllLoader.UnloadDll;
ebHandle.Text := '0';
end;

procedure TfrmMultiDllLoader.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
MultiDLLLoader.Clear;
end;

procedure TfrmMultiDllLoader.miBackClick(Sender: TObject);
begin
  inherited;
MultiDllLoader.Back;
end;

procedure TfrmMultiDllLoader.miFirstClick(Sender: TObject);
begin
  inherited;
MultiDllLoader.First;
end;

procedure TfrmMultiDllLoader.miLastClick(Sender: TObject);
begin
  inherited;
MultiDllLoader.Last;
end;

procedure TfrmMultiDllLoader.miLoadAllClick(Sender: TObject);
begin
  inherited;
MultiDllLoader.LoadAll;
end;

procedure TfrmMultiDllLoader.miNextClick(Sender: TObject);
begin
  inherited;
MultiDllLoader.Next;
end;

procedure TfrmMultiDllLoader.miUnloadAllClick(Sender: TObject);
begin
  inherited;
MultiDllLoader.UnloadAll;
end;

procedure TfrmMultiDllLoader.MultiDLLLoaderAfterAddEvent(Sender: TObject);
begin
  inherited;
AddToListView('OnAfterAddEvent: ' + IntToStr(MultiDLLLoader.CurrentIndex) + ' [' +
                ExtractFilename(MultiDLLLoader.Filename) + ' ]');
end;

procedure TfrmMultiDllLoader.MultiDLLLoaderAfterLoadAllEvent(Sender: TObject);
begin
  inherited;
AddToListView('OnAfterLoadAllEvent: ' + IntToStr(MultiDLLLoader.CurrentIndex) + ' [' +
                ExtractFilename(MultiDLLLoader.Filename) + ' ]');

end;

procedure TfrmMultiDllLoader.MultiDLLLoaderAfterUnloadALllEvent(
  Sender: TObject);
begin
  inherited;
AddToListView('OnAfterUnloadAllEvent: ' + IntToStr(MultiDLLLoader.CurrentIndex) + ' [' +
                ExtractFilename(MultiDLLLoader.Filename) + ' ]');

end;

procedure TfrmMultiDllLoader.MultiDLLLoaderArrayNotInSyncError(Sender: TObject);
begin
  inherited;
AddToListView('OnArrayNotInSyncError');

end;

procedure TfrmMultiDllLoader.MultiDLLLoaderBeforeAddEvent(Sender: TObject);
begin
  inherited;
AddToListView('OnBeforeAddEvent: ' + IntToStr(MultiDLLLoader.CurrentIndex) + ' [' +
                ExtractFilename(MultiDLLLoader.Filename) + ' ]');
end;

procedure TfrmMultiDllLoader.MultiDLLLoaderBeforeLoadAllEvent(Sender: TObject);
begin
  inherited;
AddToListView('OnBeforeLoadAll: ' + IntToStr(MultiDLLLoader.CurrentIndex) + ' [' +
                ExtractFilename(MultiDLLLoader.Filename) + ' ]');
end;

procedure TfrmMultiDllLoader.MultiDLLLoaderBeforeUnloadAllEvent(
  Sender: TObject);
begin
  inherited;
AddToListView('OnBeforeUnloadAllEvent: ' + IntToStr(MultiDLLLoader.CurrentIndex) + ' [' +
                ExtractFilename(MultiDLLLoader.Filename) + ' ]');
end;

procedure TfrmMultiDllLoader.MultiDLLLoaderClearEvent(Sender: TObject);
begin
  inherited;
AddToListView('ClearEvent');
end;

procedure TfrmMultiDllLoader.MultiDLLLoaderNavigateEvent(Sender: TObject);
begin
  inherited;
  ebFileName.Text := MultiDLLLoader.Filename;
  ebHandle.Text := IntToStr(MultiDLLLoader.Handle);
end;

procedure TfrmMultiDllLoader.MultiDLLLoaderStateChangedEvent(Sender: TObject);
begin
 // inherited;
ebFileName.Text := MultiDLLLoader.Filename;
ebHandle.Text := IntToStr(MultiDLLLoader.Handle);

end;

end.
