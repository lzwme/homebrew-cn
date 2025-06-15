cask "xamarin-workbooks" do
  version "1.5.0"
  sha256 "1fb3cebb67d0fc68f56a38485ea7ea015f7b294893455c458dc39a2b63d1d6dd"

  url "https:github.comMicrosoftworkbooksreleasesdownloadv#{version}XamarinInteractive-#{version}.pkg",
      verified: "github.comMicrosoftworkbooks"
  name "Xamarin Workbooks"
  desc "C# documentation and coding materials"
  homepage "https:docs.microsoft.comen-usxamarintoolsworkbooks"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :el_capitan"

  pkg "XamarinInteractive-#{version}.pkg"

  uninstall pkgutil: "com.xamarin.Inspector"
end