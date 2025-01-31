cask "frappe-books" do
  arch arm: "-arm64"

  version "0.27.0"
  sha256 arm:   "83af06506cb00f714f3cef2986d47d6783d231f36ba3fe3488bd205c57660c2a",
         intel: "4b829afa622f383961903a5f6679be04e6f55eb71b5a86e227b267aad23e27d0"

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