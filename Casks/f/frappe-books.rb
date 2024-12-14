cask "frappe-books" do
  arch arm: "-arm64"

  version "0.25.0"
  sha256 arm:   "ce685fc0c730a439a70c120bd8c0edbedd49d205d9faf3bb2d4371ae48c02888",
         intel: "a8080d6e1d9551ec52b47417ef495b6586bbad7d83cbd2dc06fdc12e4770d1be"

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