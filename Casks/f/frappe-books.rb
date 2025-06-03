cask "frappe-books" do
  arch arm: "-arm64"

  version "0.31.0"
  sha256 arm:   "f20a2f18521b6757dfe459d8808175c2a84c057c1ccfbbca1ca08432790d719c",
         intel: "7e96c1055aaa0ad7bc535efacb936e27b7069e73a8dc2ffb65986b2af294d338"

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