cask "taskexplorer" do
  version "2.1.0"
  sha256 "bf509f14cabdadaa81bc3509d195b8646ee203ceba15aba26d26c6b882422ccd"

  url "https:github.comobjective-seeTaskExplorerreleasesdownloadv#{version}TaskExplorer_#{version}.zip",
      verified: "github.comobjective-see"
  name "TaskExplorer"
  desc "Tool to explore all the running tasks (processes)"
  homepage "https:objective-see.orgproductstaskexplorer.html"

  depends_on macos: ">= :big_sur"

  app "TaskExplorer.app"

  uninstall_preflight do
    set_ownership "#{appdir}TaskExplorer.app"
  end

  zap trash: [
    "~LibraryCachescom.objective-see.TaskExplorer",
    "~LibraryHTTPStoragescom.objective-see.TaskExplorer",
    "~LibraryPreferencescom.objective-see.TaskExplorer.plist",
  ]
end