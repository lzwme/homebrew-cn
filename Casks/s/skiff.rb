cask "skiff" do
  version "0.4.0"
  sha256 "283b7b8f594095f0049201ff9433d77b5e504dfa84e7b9736a4447a692e1b514"

  url "https:raw.githubusercontent.comskiff-orgskiff-org.github.iomainmacosSkiff%20Desktop%20#{version}.dmg",
      verified: "raw.githubusercontent.comskiff-orgskiff-org.github.iomainmacos"
  name "Skiff"
  desc "End-to-end encrypted email, calendar, documents, and files support"
  homepage "https:skiff.com"

  deprecate! date: "2023-12-17", because: :moved_to_mas

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Skiff Desktop.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.reactjs.native.Skiff-Desktop",
    "~LibraryContainersorg.reactjs.native.Skiff-Desktop",
  ]
end