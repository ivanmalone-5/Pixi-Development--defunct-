unit ufraPixiPluginServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ComCtrls, Vcl.ActnList,
  Vcl.Menus, Vcl.ExtCtrls, udmPixiPluginServer, Vcl.ToolWin, Vcl.ImgList;

type
  TfraPixiPluginServer = class(TFrame)
    ActionList: TActionList;
    actRefreshListView: TAction;
    OpenDialog: TOpenDialog;
    actAddPlugins: TAction;
    ListViewMenu: TPopupMenu;
    AddPlugins1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    StatusBar: TStatusBar;
    ListView: TListView;
    actPluginFirst: TAction;
    actPluginLast: TAction;
    actPluginBack: TAction;
    actPluginNext: TAction;
    actPluginLoad: TAction;
    actPluginUnload: TAction;
    actPluginLoadAll: TAction;
    actPluginUnloadAll: TAction;
    N2: TMenuItem;
    Select1: TMenuItem;
    First1: TMenuItem;
    Next1: TMenuItem;
    Next2: TMenuItem;
    Last1: TMenuItem;
    N3: TMenuItem;
    Load1: TMenuItem;
    Unload1: TMenuItem;
    N4: TMenuItem;
    actPluginLoadAll1: TMenuItem;
    actPluginUnloadAll1: TMenuItem;
    actPluginClear: TAction;
    actPluginRemove: TAction;
    N5: TMenuItem;
    Remove1: TMenuItem;
    Clear1: TMenuItem;
    actListviewReport: TAction;
    actListViewList: TAction;
    actListViewSmall: TAction;
    actListViewIcon: TAction;
    actListviewGroups: TAction;
    ActionListImages: TImageList;
    actPluginAddPath: TAction;
    AddPath1: TMenuItem;
    Plugins1: TMenuItem;
    View1: TMenuItem;
    Detailed1: TMenuItem;
    List1: TMenuItem;
    List2: TMenuItem;
    Small1: TMenuItem;
    N6: TMenuItem;
    Groups1: TMenuItem;
    N7: TMenuItem;
    TreeView: TTreeView;
    procedure actRefreshListViewExecute(Sender: TObject);
    procedure actAddPluginsExecute(Sender: TObject);
    procedure actPluginLoadAllExecute(Sender: TObject);
    procedure actPluginUnloadAllExecute(Sender: TObject);
    procedure actPluginLoadExecute(Sender: TObject);
    procedure actPluginUnloadExecute(Sender: TObject);
    procedure actPluginNextExecute(Sender: TObject);
    procedure actPluginBackExecute(Sender: TObject);
    procedure actPluginFirstExecute(Sender: TObject);
    procedure actPluginLastExecute(Sender: TObject);
    procedure actPluginClearExecute(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure actPluginRemoveExecute(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure actListviewReportExecute(Sender: TObject);
    procedure actListViewListExecute(Sender: TObject);
    procedure actListViewSmallExecute(Sender: TObject);
    procedure actListViewIconExecute(Sender: TObject);
    procedure actListviewGroupsExecute(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    dmPixiPluginServer        :         TdmPixiPluginServer;
    CONSTRUCTOR Create(AOwner : TComponent); override;
    DESTRUCTOR Destroy(); override;
  end;

implementation
uses  uPluginManager, uDLLManager;


{$R *.dfm}


CONSTRUCTOR TfraPixiPluginServer.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  dmPixiPluginServer := TdmPixiPluginServer.Create(Self);
end;

DESTRUCTOR TfraPixiPluginServer.Destroy;
begin
  dmPixiPluginServer.Free;
  Inherited Destroy();
end;

procedure TfraPixiPluginServer.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
dmPixiPluginServer.PluginManager.Select(dmPixiPluginServer.PluginManager.FindByFileName(Item.Caption));
end;

procedure TfraPixiPluginServer.ListViewClick(Sender: TObject);
begin
//if ListView.SelCount > 0 then
//   Begin
//   for i := 0 to ListView.Items.Count - 1 do
//        Begin
//          if ListView.Items.Item[i].Selected then
//             Begin
//             dmPixiPluginServer.PluginManager.Select(dmPixiPluginServer.PluginManager.FindByFileName(ListView.Items.Item[i].Caption));
//             sELF.actRefreshListView.Execute;
//             Break;
//             End;
//        End;
//   End;
end;

procedure TfraPixiPluginServer.actAddPluginsExecute(Sender: TObject);
Var
  i   :   integer;
begin
if OpenDialog.Execute then
  Begin
  if OpenDialog.Files.Count > 1 then
     Begin
      for i := 0 to OpenDialog.Files.Count - 1 do
        Begin
//        dmPixiPluginServer.PluginManager.AddMultiple(OpenDialog.Files);
        dmPixiPluginServer.PluginManager.Add(OpenDialog.Files.Strings[i]);
        End;
     End
  ELSE if OpenDialog.Files.Count = 1 then
      Begin
        dmPixiPluginServer.PluginManager.Add(OpenDialog.FileName);
      End;


  actRefreshListView.Execute;
  End;
end;

procedure TfraPixiPluginServer.actListviewGroupsExecute(Sender: TObject);
begin
ListView.GroupView := not listview.GroupView;
actlistviewgroups.Checked := listview.GroupView;
end;

procedure TfraPixiPluginServer.actListViewIconExecute(Sender: TObject);
begin
ListView.ViewStyle := vsIcon;
actListViewIcon.Checked := True;
end;

procedure TfraPixiPluginServer.actListViewListExecute(Sender: TObject);
begin
ListView.ViewStyle := vsList;
actListViewList.Checked := True;
end;

procedure TfraPixiPluginServer.actListviewReportExecute(Sender: TObject);
begin
ListView.ViewStyle := vsReport;
actListViewReport.Checked := True;
end;

procedure TfraPixiPluginServer.actListViewSmallExecute(Sender: TObject);
begin
ListView.ViewStyle := vsSmallIcon;
actListViewSmall.Checked := True;
end;

procedure TfraPixiPluginServer.actPluginBackExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   dmPixiPluginServer.PluginManager.Back;
   StatusBar.Panels.Items[0].Text := 'Count: ' + IntToStr(dmPixiPluginServer.PluginManager.Count);
   StatusBar.Panels.Items[1].Text := 'Selected: ' + ExtractFileName(dmPixiPluginServer.PluginManager.Filename);

   End;

end;

procedure TfraPixiPluginServer.actPluginClearExecute(Sender: TObject);
begin
dmPixiPluginServer.PluginManager.Clear;
actRefreshListView.Execute;
end;

procedure TfraPixiPluginServer.actPluginFirstExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   dmPixiPluginServer.PluginManager.First;
   StatusBar.Panels.Items[0].Text := 'Count: ' + IntToStr(dmPixiPluginServer.PluginManager.Count);
   StatusBar.Panels.Items[1].Text := 'Selected: ' + ExtractFileName(dmPixiPluginServer.PluginManager.Filename);

   End;

end;

procedure TfraPixiPluginServer.actPluginLastExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   dmPixiPluginServer.PluginManager.Last;
   StatusBar.Panels.Items[0].Text := 'Count: ' + IntToStr(dmPixiPluginServer.PluginManager.Count);
   StatusBar.Panels.Items[1].Text := 'Selected: ' + ExtractFileName(dmPixiPluginServer.PluginManager.Filename);
   End;

end;

procedure TfraPixiPluginServer.actPluginLoadAllExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   if dmPixiPluginServer.PluginManager.LoadAll then
      Begin
        // Loaded Ok
          actRefreshListView.Execute;
      End
   ELSE
      Begin
        // Something failed to load
          actRefreshListView.Execute;
      End;
   end;
end;

procedure TfraPixiPluginServer.actPluginLoadExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
     if dmPixiPluginServer.PluginManager.LoadDll > 0 then
        Begin
          // Loaded ok
        actRefreshListView.Execute;
        End
     ELSE
        Begin
          // Didn't load
        End;
   End;
end;

procedure TfraPixiPluginServer.actPluginNextExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   dmPixiPluginServer.PluginManager.Next;
   StatusBar.Panels.Items[0].Text := 'Count: ' + IntToStr(dmPixiPluginServer.PluginManager.Count);
   StatusBar.Panels.Items[1].Text := 'Selected: ' + ExtractFileName(dmPixiPluginServer.PluginManager.Filename);

   End;

end;

procedure TfraPixiPluginServer.actPluginRemoveExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   dmPixiPluginServer.PluginManager.Remove;
   End;
end;

procedure TfraPixiPluginServer.actPluginUnloadAllExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   if dmPixiPluginServer.PluginManager.UnloadAll then
      Begin
        // All Unloaded Ok
          actRefreshListView.Execute;
      End
   ELSE
      Begin
        // Something went wrong unloading something
          actRefreshListView.Execute;
      End;
   End;
end;

procedure TfraPixiPluginServer.actPluginUnloadExecute(Sender: TObject);
begin
if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
   if dmPixiPluginServer.PluginManager.UnloadDll then
      Begin
        // Unloaded ok
          actRefreshListView.Execute;
      End
   ELSE
      Begin
        // Didn't unload ok
      End;
   End;
end;

procedure TfraPixiPluginServer.actRefreshListViewExecute(Sender: TObject);
Var
  ListItem    :     TListItem;
  ListGroup   :     TListGroup;
  i           :     integer;
  DLLInfo     :     TDLLInfoRec;
  PrevIndex   :     Integer;
begin

if dmPixiPluginServer.PluginManager.Count > 0 then
   Begin
     // Fill listview with plugins
    PrevIndex := dmPixiPluginServer.PluginManager.CurrentIndex;


     ListView.Items.BeginUpdate;
     ListView.Items.Clear;
//    dmPixiPluginServer.PluginManager.First;

     for i := 0 to dmPixiPluginServer.PluginManager.Count - 1 do
          Begin
          DLLInfo := dmPixiPluginServer.PluginManager.Get(i);

          ListItem := ListView.Items.Add;
          ListGroup := ListView.Groups.Add;

          ListGroup.Header := ExtractFileName(DLLInfo.Filename);
          ListGroup.GroupID := i;

          ListItem.Caption := ExtractFileName(DLLInfo.Filename);

          ListItem.SubItems.Add(ExtractFilePath(DLLInfo.Filename));

          ListItem.GroupID := i;

          if DLLInfo.Handle > 0 then
             Begin
             ListItem.SubItems.Add('YES');
             End
          ELSE
             Begin
             ListItem.SubItems.Add('NO');
             End;

          if DLLInfo.Handle > 0 then
             Begin
               ListItem.SubItems.Add('YES');
             End
          ELSE
             Begin
               ListItem.SubItems.Add('NO');
             End;

          ListItem.SubItems.Add(IntToStr(DLLInfo.Handle));

//          dmPixiPluginServer.PluginManager.Next;
          End;

     ListView.Items.EndUpdate;

    dmPixiPluginServer.PluginManager.Select(PrevIndex);
   End
ELSE
   Begin
     // Clear Listview
     ListView.Clear;
   End;

end;

end.
