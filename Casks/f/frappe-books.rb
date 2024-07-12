cask "frappe-books" do
  version "0.21.2"
  sha256 "9fd0a360f35d9c0745ca43b459d133b7da555122005499a8372eb6fa90719723"

  url "https:github.comfrappebooksreleasesdownloadv#{version}Frappe-Books-#{version}.dmg",
      verified: "github.comfrappebooks"
  name "Frappe Books"
  desc "Book-keeping software for small businesses and freelancers"
  homepage "https:frappe.iobooks"

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

  caveats do
    requires_rosetta
  end
end