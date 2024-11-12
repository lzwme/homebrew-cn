cask "frappe-books" do
  arch arm: "-arm64"

  version "0.24.1"
  sha256 arm:   "ccf6404bdbefc8c146ebb8294876f6a159ca3826e52bc3e39249c41f60572b7a",
         intel: "bc80e027c80aa48e420c0f387f1a5ba0065057be34a4b54f33db0984754aea31"

  url "https:github.comfrappebooksreleasesdownloadv#{version}Frappe-Books-#{version}#{arch}.dmg",
      verified: "github.comfrappebooks"
  name "Frappe Books"
  desc "Book-keeping software for small businesses and freelancers"
  homepage "https:frappe.iobooks"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Frappe Books.app"

  zap trash: [
    "~LibraryApplication Supportfrappe-books",
    "~LibraryPreferencesio.frappe.books.plist",
    "~LibrarySaved Application Stateio.frappe.books.savedState",
  ]
end