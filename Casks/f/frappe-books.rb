cask "frappe-books" do
  arch arm: "-arm64"

  version "0.26.0"
  sha256 arm:   "5ce4e227c7d38eb6f63d8557241ae30c4f5cca9aa84fcc0ab9cbe28a83343f23",
         intel: "2801d23db3a60b688ea5c676215709d32b7bf88ccb7f6a043108504a1f6b8e3b"

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