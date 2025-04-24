cask "frappe-books" do
  arch arm: "-arm64"

  version "0.29.0"
  sha256 arm:   "d794d63bb539d5eac67988168039e353420f214cee5c108744ba2bbf099201a8",
         intel: "a4535b89ab61bedf8bb7ded1682395a5aec8e3d81f5eb3df9acc63b420cfdbab"

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