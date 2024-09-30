cask "frappe-books" do
  arch arm: "-arm64"

  on_arm do
    version "0.23.0"
    sha256 "2731e2ecfe7bd7c10d8476587f0a953ef0cb9dcfa4dd19bf8d02beb0cfa2b7b7"
  end
  on_intel do
    version "0.21.2"
    sha256 "9fd0a360f35d9c0745ca43b459d133b7da555122005499a8372eb6fa90719723"
  end

  url "https:github.comfrappebooksreleasesdownloadv#{version}Frappe-Books-#{version}#{arch}.dmg",
      verified: "github.comfrappebooks"
  name "Frappe Books"
  desc "Book-keeping software for small businesses and freelancers"
  homepage "https:frappe.iobooks"

  livecheck do
    url :url
    regex(^Frappe[._-]Books[._-]v?(\d+(?:\.\d+)+)#{arch}\.dmg$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Frappe Books.app"

  zap trash: [
    "~LibraryApplication Supportfrappe-books",
    "~LibraryPreferencesio.frappe.books.plist",
    "~LibrarySaved Application Stateio.frappe.books.savedState",
  ]
end