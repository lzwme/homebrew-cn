cask "spaceid" do
  version "1.4"
  sha256 "6b867f758b2037f2c5f908ec0311d73a7e47f4da179cdde952c914fd2b33528e"

  url "https:github.comdshnkaoSpaceIdreleasesdownloadv#{version}SpaceId.app.zip"
  name "SpaceId"
  desc "Menu bar indicator showing the currently selected space"
  homepage "https:github.comdshnkaoSpaceId"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "SpaceId.app"

  preflight do
    set_permissions "#{staged_path}SpaceId.app", "0755"
  end

  uninstall login_item: "SpaceId"

  zap trash: "~LibraryPreferencescom.dshnkao.SpaceId.plist"
end