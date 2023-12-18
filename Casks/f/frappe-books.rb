cask "frappe-books" do
  version "0.19.0"
  sha256 "5fb3e743d63d85e22fca5dd19d4f7bbcb07543faf3b6575bd5c7df75da382fb8"

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