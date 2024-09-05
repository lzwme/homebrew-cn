cask "frappe-books" do
  arch arm: "-arm64"

  on_arm do
    version "0.22.0"
    sha256 "06ca67133f11f20b7aaff28f968d028db53b3e8483967493ff09a464c53fbbc6"
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