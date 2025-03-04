cask "frappe-books" do
  arch arm: "-arm64"

  version "0.28.0"
  sha256 arm:   "0304794c3549704cfd139ad666eec0da55f355ecc864e11f020225b8ea682b7c",
         intel: "4c13721c4ad9042812f24598c7d1195226e827f2625fa0062359950fff126f62"

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