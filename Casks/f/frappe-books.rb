cask "frappe-books" do
  version "0.21.1"
  sha256 "94d610d941cb5e31383c4b7b623f7867541ee0197310bb3eb4d8266dd70b085a"

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