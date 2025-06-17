cask "langflow" do
  version "1.4.2"
  sha256 "07da16749c0fe42c5d85bcf75dc7117d7d4b03c2de0acd414bcff643e568baa8"

  url "https:github.comlangflow-ailangflowreleasesdownload#{version}Langflow_aarch64.dmg",
      verified: "github.comlangflow-ailangflow"
  name "Langflow Desktop"
  desc "Low-code AI-workflow building tool"
  homepage "https:www.langflow.orgdesktop"

  # GitHub releases may not always provide a file for macOS. We check the
  # first-party download page, as it links directly to the latest macOS file
  # (i.e., we don't have to check recent GitHub releases to find the newest
  # version with a macOS file).
  livecheck do
    url "https:www.langflow.orgdesktop-form-complete"
    regex(%r{href=.*?downloadv?(\d+(?:\.\d+)+[^]*?)Langflow[^"' >]*?\.dmg}i)
  end

  no_autobump! because: :requires_manual_review

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

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