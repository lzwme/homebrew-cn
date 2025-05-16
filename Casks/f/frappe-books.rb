cask "frappe-books" do
  arch arm: "-arm64"

  version "0.30.0"
  sha256 arm:   "9f1fca9188d04fc087eab7b9eda1ad58a776e35d0707e8178fcb8abdd3dfd1fc",
         intel: "ddcff5134317c7d579efd228f36d992a4c41d52ae6ae55ee7ee362102cd51752"

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