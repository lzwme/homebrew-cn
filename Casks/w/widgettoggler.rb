cask "widgettoggler" do
  version "1.2.0"
  sha256 "4a37bd84eb391c86e80a05b3b875dae6286418f2223970dbeff03abe310b5af9"

  url "https:github.comsierenWidgetTogglerreleasesdownload#{version}WidgetToggler_#{version.major_minor}.zip"
  name "WidgetToggler"
  desc "Tool to toggle the visibility of homescreen widgets"
  homepage "https:github.comsierenWidgetToggler"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sonoma"

  app "WidgetToggler.app"

  zap trash: "~LibraryPreferencescom.sieren.WidgetToggler.plist"
end