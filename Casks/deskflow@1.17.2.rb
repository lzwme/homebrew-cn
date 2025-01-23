cask "deskflow@1.17.2" do
  arch arm: "arm64", intel: "x86_64"

  version "1.17.2"
  sha256 arm:   "1d1d771fc5ac69c8440b88557e7a59f90070141881de82152c42e5945886a935",
         intel: "ccfa8373e770883031a33159d55bbfe063365bbd6a7274b05967aa82168fc5de"

  url "https:github.comdeskflowdeskflowreleasesdownloadv#{version}deskflow-#{version}-macos-#{arch}.dmg"
  name "Deskflow"
  desc "Mouse and keyboard sharing utility"
  homepage "https:github.comdeskflowdeskflow"

  livecheck do
    skip "Pinned version"
  end

  conflicts_with cask: "deskflow-dev"
  depends_on macos: ">= :monterey"

  app "Deskflow.app"

  postflight do
    system_command "xattr",
                   args: [
                     "-c", "ApplicationsDeskflow.app"
                   ]
  end

  zap trash: [
    "~LibraryApplication SupportDeskflow",
    "~LibrarySaved Application StateDeskflow.savedState",
  ]
end