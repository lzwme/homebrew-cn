cask "frappe-books" do
  version "0.20.0"
  sha256 "23da621f8c6e9488804f3c6b2a2c5c7c0dc9484b9e6a985381d5c0736e4fefa8"

  url "https:github.comfrappebooksreleasesdownloadv#{version}Frappe-Books-#{version}.dmg",
      verified: "github.comfrappebooks"
  name "Frappe Books"
  desc "Book-keeping software for small businesses and freelancers"
  homepage "https:frappebooks.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Frappe Books.app"

  zap trash: [
    "~LibraryApplication Supportfrappe-books",
    "~LibraryPreferencesio.frappe.books.plist",
    "~LibrarySaved Application Stateio.frappe.books.savedState",
  ]
end