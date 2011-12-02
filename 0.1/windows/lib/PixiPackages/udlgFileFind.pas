unit udlgFileFind;

{------------------------------------------------------------------------------}
{ Modified from                                                                              }
{  TdlgSearchFiles v4.12                                                             }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}
{ Edit: Source modified, formatting, captilization, tabs etc have been changed
  to my own style along with form layout and other edit Ivan. 23/11/2011

  Note: If there is any licence issues, then rewrite this and the code in
  uFileFile source. Having a lazy night, most of the functionality is
  not needed. Licence might be opensource, could be freeware, look into it
  later.

  Edit2: Didn't like look and feel, redesigning layout to use MS Ribbon controls


}



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, ComCtrls, uFindFile, ImgList, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.Ribbon, Vcl.RibbonLunaStyleActnCtrls,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls;

type
  TdlgSearchFiles = class(TForm)
    FindButton: TButton;
    StopButton: TButton;
    FindFile: TFindFile;
    FoundFiles: TListView;
    StatusBar: TStatusBar;
    Threaded: TCheckBox;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    FileName: TEdit;
    Location: TEdit;
    Subfolders: TCheckBox;
    TabSheet2: TTabSheet;
    Attributes: TGroupBox;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    Phrase: TEdit;
    FileSize: TGroupBox;
    SizeMaxEdit: TEdit;
    SizeMinEdit: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    CaseSenstitive: TCheckBox;
    WholeWord: TCheckBox;
    SizeMin: TUpDown;
    SizeMax: TUpDown;
    System: TCheckBox;
    Hidden: TCheckBox;
    Readonly: TCheckBox;
    Archive: TCheckBox;
    Directory: TCheckBox;
    Compressed: TCheckBox;
    Encrypted: TCheckBox;
    Offline: TCheckBox;
    SparseFile: TCheckBox;
    ReparsePoint: TCheckBox;
    Temporary: TCheckBox;
    Device: TCheckBox;
    Normal: TCheckBox;
    NotContentIndexed: TCheckBox;
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    CreatedBeforeDate: TDateTimePicker;
    CreatedAfterDate: TDateTimePicker;
    CreatedBeforeTime: TDateTimePicker;
    CreatedAfterTime: TDateTimePicker;
    CBD: TCheckBox;
    CBT: TCheckBox;
    CAD: TCheckBox;
    CAT: TCheckBox;
    ModifiedBeforeDate: TDateTimePicker;
    ModifiedAfterDate: TDateTimePicker;
    ModifiedBeforeTime: TDateTimePicker;
    ModifiedAfterTime: TDateTimePicker;
    MBD: TCheckBox;
    MBT: TCheckBox;
    MAD: TCheckBox;
    MAT: TCheckBox;
    AccessedBeforeDate: TDateTimePicker;
    AccessedAfterDate: TDateTimePicker;
    AccessedBeforeTime: TDateTimePicker;
    AccessedAfterTime: TDateTimePicker;
    ABD: TCheckBox;
    ABT: TCheckBox;
    AAD: TCheckBox;
    AAT: TCheckBox;
    PopupMenu: TPopupMenu;
    OpenFileItem: TMenuItem;
    OpenFileLocationItem: TMenuItem;
    Virtual: TCheckBox;
    ProgressImageTimer: TTimer;
    ProgressImages: TImageList;
    ProgressImagePanel: TPanel;
    ProgressImage: TImage;
    SizeMinUnit: TComboBox;
    SizeMaxUnit: TComboBox;
    TabSheet7: TTabSheet;
    Filters: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Negate: TCheckBox;
    Ribbon1: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    RibbonPage2: TRibbonPage;
    RibbonPage3: TRibbonPage;
    RibbonPage4: TRibbonPage;
    ActionManager: TActionManager;
    actStop: TAction;
    Action1: TAction;
    procedure FindButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure FindFileFolderChange(Sender: TObject; const Folder: String;
      var IgnoreFolder: TFolderIgnore);
    procedure FindFileFileMatch(Sender: TObject; const FileInfo: TFileDetails);
    procedure FoundFilesColumnClick(Sender: TObject; Column: TListColumn);
    procedure FoundFilesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FindFileSearchFinish(Sender: TObject);
    procedure FoundFilesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBDClick(Sender: TObject);
    procedure CBTClick(Sender: TObject);
    procedure CADClick(Sender: TObject);
    procedure CATClick(Sender: TObject);
    procedure MBDClick(Sender: TObject);
    procedure MBTClick(Sender: TObject);
    procedure MADClick(Sender: TObject);
    procedure MATClick(Sender: TObject);
    procedure ABDClick(Sender: TObject);
    procedure ABTClick(Sender: TObject);
    procedure AADClick(Sender: TObject);
    procedure AATClick(Sender: TObject);
    procedure FindFileSearchBegin(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OpenFileItemClick(Sender: TObject);
    procedure OpenFileLocationItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ProgressImageTimerTimer(Sender: TObject);
  private
    Folders: Integer;
    StartTime: DWord;
    SortedColumn: Integer;
    Descending: Boolean;
  end;

var
  dlgSearchFiles: TdlgSearchFiles;

implementation

{$R *.DFM}

uses
  {$IFDEF COMPILER7_UP} XPMan, {$ENDIF} ShellAPI;

function GetAttributeStatus(CB: TCheckBox): TFileAttributeStatus;
begin
  case CB.State of
    cbUnchecked: Result := fsUnset;
    cbChecked: Result := fsSet;
  else
    Result := fsIgnore;
  end;
end;

procedure TdlgSearchFiles.FindButtonClick(Sender: TObject);
begin
  // Sets FileFile properties
  FindFile.Threaded := Threaded.Checked;
  // - Name & Location
  with FindFile.Criteria.Files do
  begin
    FileName := Self.FileName.Text;
    Location := Self.Location.Text;
    Subfolders := Self.Subfolders.Checked;
    Filters.Assign(Self.Filters.Lines);
  end;
  // - Containing Text
  with FindFile.Criteria.Content do
  begin
    Phrase := Self.Phrase.Text;
    Options := [];
    if Self.CaseSenstitive.Checked then
      Options := Options + [csoCaseSensitive];
    if Self.WholeWord.Checked then
      Options := Options + [csoWholeWord];
    if Self.Negate.Checked then
      Options := Options + [csoNegate];
  end;
  // - Attributes
  with FindFile.Criteria.Attributes do
  begin
    Archive := GetAttributeStatus(Self.Archive);
    Readonly := GetAttributeStatus(Self.Readonly);
    Hidden := GetAttributeStatus(Self.Hidden);
    System := GetAttributeStatus(Self.System);
    Directory := GetAttributeStatus(Self.Directory);
    Compressed := GetAttributeStatus(Self.Compressed);
    Encrypted := GetAttributeStatus(Self.Encrypted);
    Offline := GetAttributeStatus(Self.Offline);
    ReparsePoint := GetAttributeStatus(Self.ReparsePoint);
    SparseFile := GetAttributeStatus(Self.SparseFile);
    Temporary := GetAttributeStatus(Self.Temporary);
    Device := GetAttributeStatus(Self.Device);
    Normal := GetAttributeStatus(Self.Normal);
    Virtual := GetAttributeStatus(Self.Virtual);
    NotContentIndexed := GetAttributeStatus(Self.NotContentIndexed);
  end;
  // - Size ranges
  with FindFile.Criteria.Size do
  begin
    Min := Self.SizeMin.Position;
    case Self.SizeMinUnit.ItemIndex of
      1: Min := Min * 1024;
      2: Min := Min * 1024 * 1024;
      3: Min := Min * 1024 * 1024 * 1024;
    end;
    Max := Self.SizeMax.Position;
    case Self.SizeMaxUnit.ItemIndex of
      1: Max := Max * 1024;
      2: Max := Max * 1024 * 1024;
      3: Max := Max * 1024 * 1024 * 1024;
    end;
  end;
  // - TimeStamp ranges
  with FindFile.Criteria.TimeStamp do
  begin
    Clear;
    // Created on
    if Self.CBD.Checked then
      CreatedBefore := Self.CreatedBeforeDate.Date;
    if Self.CBT.Checked then
      CreatedBefore := CreatedBefore + Self.CreatedBeforeTime.Time;
    if Self.CAD.Checked then
      CreatedAfter := Self.CreatedAfterDate.Date;
    if Self.CAT.Checked then
      CreatedAfter := CreatedAfter + Self.CreatedAfterTime.Time;
    // Modified on
    if Self.MBD.Checked then
      ModifiedBefore := Self.ModifiedBeforeDate.Date;
    if Self.MBT.Checked then
      ModifiedBefore := ModifiedBefore + Self.ModifiedBeforeTime.Time;
    if Self.MAD.Checked then
      ModifiedAfter := Self.ModifiedAfterDate.Date;
    if Self.MAT.Checked then
      ModifiedAfter := ModifiedAfter + Self.ModifiedAfterTime.Time;
    // Accessed on
    if Self.ABD.Checked then
      AccessedBefore := Self.AccessedBeforeDate.Date;
    if Self.ABT.Checked then
      AccessedBefore := AccessedBefore + Self.AccessedBeforeTime.Time;
    if Self.AAD.Checked then
      AccessedAfter := Self.AccessedAfterDate.Date;
    if Self.AAT.Checked then
      AccessedAfter := AccessedAfter + Self.AccessedAfterTime.Time;
  end;
  // Begins search
  FindFile.Execute;
end;

procedure TdlgSearchFiles.StopButtonClick(Sender: TObject);
begin
  FindFile.Abort;
  StatusBar.SimpleText := 'Cancelling search, please wait...';
end;

procedure TdlgSearchFiles.FindFileSearchBegin(Sender: TObject);
begin
  Folders := 0;
  SortedColumn := -1;
  FoundFiles.SortType := stNone;
  FoundFiles.Items.BeginUpdate;
  FoundFiles.Items.Clear;
  FoundFiles.Items.EndUpdate;
  FindButton.Enabled := False;
  StopButton.Enabled := True;
  Threaded.Enabled := False;
  ProgressImagePanel.Visible := True;
  ProgressImageTimer.Enabled := True;
  StartTime := GetTickCount;
end;

procedure TdlgSearchFiles.FindFileSearchFinish(Sender: TObject);
begin
  StatusBar.SimpleText := Format('%d folder(s) searched and %d file(s) found - %.3f second(s)',
    [Folders, FoundFiles.Items.Count, (GetTickCount - StartTime) / 1000]);
  if FindFile.Aborted then
    StatusBar.SimpleText := 'Search cancelled - ' + StatusBar.SimpleText;
  ProgressImageTimer.Enabled := False;
  ProgressImagePanel.Visible := False;
  Threaded.Enabled := True;
  StopButton.Enabled := False;
  FindButton.Enabled := True;
end;

procedure TdlgSearchFiles.FindFileFolderChange(Sender: TObject; const Folder: String;
  var IgnoreFolder: TFolderIgnore);
begin
  Inc(Folders);
  StatusBar.SimpleText := Folder;
  if not FindFile.Threaded then
    Application.ProcessMessages;
end;

procedure TdlgSearchFiles.FindFileFileMatch(Sender: TObject;
  const FileInfo: TFileDetails);
begin
  with FoundFiles.Items.Add do
  begin
    Caption := FileInfo.Name;
    SubItems.Add(FileInfo.Location);
    if LongBool(FileInfo.Attributes and FILE_ATTRIBUTE_DIRECTORY) then
      SubItems.Add('Folder')
    else
      SubItems.Add(FormatFileSize(FileInfo.Size));
    SubItems.Add(DateTimeToStr(FileInfo.ModifiedTime));
  end;
  if not FindFile.Threaded then
    Application.ProcessMessages;
end;

procedure TdlgSearchFiles.FoundFilesColumnClick(Sender: TObject; Column: TListColumn);
begin
  if not FindFile.Busy then
  begin
    TListView(Sender).SortType := stNone;
    if Column.Index <> SortedColumn then
    begin
      SortedColumn := Column.Index;
      Descending := False;
    end
    else
      Descending := not Descending;
    TListView(Sender).SortType := stText;
  end
  else
    MessageDlg('Cannot sort the list while a search is in progress.', mtWarning, [mbOK], 0);
end;

procedure TdlgSearchFiles.FoundFilesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortedColumn = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else if SortedColumn > 0 then
    Compare := CompareText(Item1.SubItems[SortedColumn-1],
                           Item2.SubItems[SortedColumn-1]);
  if Descending then Compare := -Compare;
end;

procedure TdlgSearchFiles.FoundFilesDblClick(Sender: TObject);
begin
  OpenFileItemClick(nil);
end;

procedure TdlgSearchFiles.OpenFileItemClick(Sender: TObject);
begin
  if FoundFiles.Selected <> nil then
    with FoundFiles.Selected do
      ShellExecute(0, 'Open', PChar(Caption), nil, PChar(SubItems[0]), SW_NORMAL);
end;

procedure TdlgSearchFiles.OpenFileLocationItemClick(Sender: TObject);
var
  Param: String;
begin
  if FoundFiles.Selected <> nil then
  begin
    with FoundFiles.Selected do
      Param := Format('/n,/select,"%s%s"', [SubItems[0], Caption]);
    ShellExecute(0, 'Open', 'explorer.exe', PChar(Param), nil, SW_NORMAL);
  end;
end;

procedure TdlgSearchFiles.PopupMenuPopup(Sender: TObject);
begin
  OpenFileItem.Enabled := (FoundFiles.Selected <> nil);
  OpenFileLocationItem.Enabled := (FoundFiles.Selected <> nil);
end;

procedure TdlgSearchFiles.FormCreate(Sender: TObject);
begin
  CreatedBeforeDate.Date := Date;
  CreatedBeforeDate.Time := 0;
  CreatedAfterDate.Date := Date;
  CreatedAfterDate.Time := 0;
  CreatedBeforeTime.Time := Time;
  CreatedBeforeTime.Date := 0;
  CreatedAfterTime.Time := Time;
  CreatedAfterTime.Date := 0;
  ModifiedBeforeDate.Date := Date;
  ModifiedBeforeDate.Time := 0;
  ModifiedAfterDate.Date := Date;
  ModifiedAfterDate.Time := 0;
  ModifiedBeforeTime.Time := Time;
  ModifiedBeforeTime.Date := 0;
  ModifiedAfterTime.Time := Time;
  ModifiedAfterTime.Date := 0;
  AccessedBeforeDate.Date := Date;
  AccessedBeforeDate.Time := 0;
  AccessedAfterDate.Date := Date;
  AccessedAfterDate.Time := 0;
  AccessedBeforeTime.Time := Time;
  AccessedBeforeTime.Date := 0;
  AccessedAfterTime.Time := Time;
  AccessedAfterTime.Date := 0;
  {$IFDEF COMPILER4_UP}
  ProgressImagePanel.DoubleBuffered := True;
  {$ENDIF}
  ProgressImages.GetBitmap(0, ProgressImage.Picture.Bitmap);
end;

procedure TdlgSearchFiles.CBDClick(Sender: TObject);
begin
  CreatedBeforeDate.Enabled := CBD.Checked;
end;

procedure TdlgSearchFiles.CBTClick(Sender: TObject);
begin
  CreatedBeforeTime.Enabled := CBT.Checked;
end;

procedure TdlgSearchFiles.CADClick(Sender: TObject);
begin
  CreatedAfterDate.Enabled := CAD.Checked;
end;

procedure TdlgSearchFiles.CATClick(Sender: TObject);
begin
  CreatedAfterTime.Enabled := CAT.Checked;
end;

procedure TdlgSearchFiles.MBDClick(Sender: TObject);
begin
  ModifiedBeforeDate.Enabled := MBD.Checked;
end;

procedure TdlgSearchFiles.MBTClick(Sender: TObject);
begin
  ModifiedBeforeTime.Enabled := MBT.Checked;
end;

procedure TdlgSearchFiles.MADClick(Sender: TObject);
begin
  ModifiedAfterDate.Enabled := MAD.Checked;
end;

procedure TdlgSearchFiles.MATClick(Sender: TObject);
begin
  ModifiedAfterTime.Enabled := MAT.Checked;
end;

procedure TdlgSearchFiles.ABDClick(Sender: TObject);
begin
  AccessedBeforeDate.Enabled := ABD.Checked;
end;

procedure TdlgSearchFiles.ABTClick(Sender: TObject);
begin
  AccessedBeforeTime.Enabled := ABT.Checked;
end;

procedure TdlgSearchFiles.AADClick(Sender: TObject);
begin
  AccessedAfterDate.Enabled := AAD.Checked;
end;

procedure TdlgSearchFiles.AATClick(Sender: TObject);
begin
  AccessedAfterTime.Enabled := AAT.Checked;
end;

procedure TdlgSearchFiles.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FindFile.Busy then FindFile.Abort;
end;

procedure TdlgSearchFiles.ProgressImageTimerTimer(Sender: TObject);
begin
  ProgressImages.Tag := (ProgressImages.Tag + 1) mod ProgressImages.Count;
  ProgressImages.GetBitmap(ProgressImages.Tag, ProgressImage.Picture.Bitmap);
  ProgressImage.Refresh;
end;

end.
