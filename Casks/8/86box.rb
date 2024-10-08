cask "86box" do
  version "4.2.1,6130"
  sha256 "019e6ac4f156c07fbf2a1a45984725af9507d0569d333334f6ac99e1a056d724"

  url "https:github.com86Box86Boxreleasesdownloadv#{version.csv.first}86Box-macOS-x86_64+arm64-b#{version.csv.second}.zip",
      verified: "github.com86Box86Box"
  name "86Box"
  desc "Emulator of x86-based machines based on PCem"
  homepage "https:86box.net"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)*)86Box[._-]macOS.*?[._-]b(\d+)\.zip$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: ">= :mojave"

  app "86Box.app", target: "86Box86Box.app"

  roms_dir = Pathname("~LibraryApplication Supportnet.86box.86Boxroms")

  preflight do
    roms_dir.expand_path.mkpath
  end

  zap trash: [
    "Applications86Box",
    "~LibraryApplication Supportnet.86box.86Box",
    "~LibrarySaved Application Statenet.86Box.86Box.savedState",
  ]

  caveats do
    <<~EOS
      The latest ROM files from https:github.com86Boxroms need to be installed into:

        #{roms_dir}
    EOS
  end
end