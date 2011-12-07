unit ufraListView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ActnList;

type
  TfraListView = class(TFrame)
    ListView: TListView;
    actListviewReport: TAction;
    actListViewList: TAction;
    actListViewSmall: TAction;
    actListViewIcon: TAction;
    actListviewGroups: TAction;
    procedure actListviewReportExecute(Sender: TObject);
    procedure actListViewListExecute(Sender: TObject);
    procedure actListViewSmallExecute(Sender: TObject);
    procedure actListViewIconExecute(Sender: TObject);
    procedure actListviewGroupsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfraListView.actListviewGroupsExecute(Sender: TObject);
begin
ListView.GroupView := not listview.GroupView;
actlistviewgroups.Checked := listview.GroupView;
end;

procedure TfraListView.actListViewIconExecute(Sender: TObject);
begin
ListView.ViewStyle := vsIcon;
actListViewIcon.Checked := True;

end;

procedure TfraListView.actListViewListExecute(Sender: TObject);
begin
ListView.ViewStyle := vsList;
actListViewList.Checked := True;
end;

procedure TfraListView.actListviewReportExecute(Sender: TObject);
begin
ListView.ViewStyle := vsReport;
actListViewReport.Checked := True;
end;

procedure TfraListView.actListViewSmallExecute(Sender: TObject);
begin
ListView.ViewStyle := vsSmallIcon;
actListViewSmall.Checked := True;
end;

end.
