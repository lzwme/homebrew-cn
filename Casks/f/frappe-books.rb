cask "frappe-books" do
  version "0.20.1"
  sha256 "2581cdab7ffdda0357cf611c6cbc86901028782964bf7ad7e2abbe4f0e7e73bd"

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