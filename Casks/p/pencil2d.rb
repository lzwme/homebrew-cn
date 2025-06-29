cask "pencil2d" do
  version "0.7.0"
  sha256 "2e0d6a2cce4577e0f0f673189658893ec2182e6a16d4332d98dde21c55899595"

  url "https:github.compencil2dpencilreleasesdownloadv#{version}pencil2d-mac-#{version}.zip",
      verified: "github.compencil2dpencil"
  name "Pencil2D"
  name "Pencil2D Animation"
  desc "Open-source tool to make 2D hand-drawn animations"
  homepage "https:www.pencil2d.org"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Pencil2D.app"

  zap trash: [
    "~LibraryApplication SupportPencil2D",
    "~LibraryPreferencescom.pencil.Pencil.plist",
    "~LibrarySaved Application Statecom.pencil2d.Pencil2D.savedState",
  ]

  caveats do
    requires_rosetta
  end
end