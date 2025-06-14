cask "tartelet" do
  version "0.12.0"
  sha256 "2733db56fb15835df2e22cf8191d4f9cfc385d9779aa02d88649631fb85b016a"

  url "https:github.comshapehqtarteletreleasesdownload#{version}Tartelet.zip"
  name "Tartelet"
  desc "Manage GitHub Actions runners in virtual machines"
  homepage "https:github.comshapehqtartelet"

  depends_on macos: ">= :sonoma"

  app "Tartelet.app"

  zap trash: "~LibraryPreferencesdk.shape.Tartelet.plist"
end