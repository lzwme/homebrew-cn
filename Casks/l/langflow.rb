cask "langflow" do
  version "1.4.2"
  sha256 "42a7d642db5b75c671cbdf40faa5d87163cf34bb35b50e1537cd47fef49eb637"

  url "https:github.comlangflow-ailangflowreleasesdownload#{version}Langflow_#{version}_aarch64.dmg",
      verified: "github.comlangflow-ailangflow"
  name "Langflow Desktop"
  desc "Low-code AI-workflow building tool"
  homepage "https:www.langflow.orgdesktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "Langflow.app"

  zap trash: [
    "~.langflow",
    "~LibraryCachescom.Langflow",
    "~LibraryCacheslangflow",
    "~LibraryLogscom.Langflow",
    "~LibraryPreferencescom.Langflow.plist",
    "~LibraryWebKitcom.Langflow",
  ]
end