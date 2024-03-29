class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.1v2.36.1.tar.gz"
  sha256 "24193f6213c8aae9e8c93662cceb91773e977a1f0c741d4c69295f4b2b61a45d"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02e64335d929f9f4452d9ebfdae3e0167197645dbf620d7c1489de14f6a40ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6915015325c927840305fcdb65c77be6f1450297c003eed1dea2cdbc035c9796"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "128e84382417f278f642f7c3c04606ba03b2a75a645b85717044de01e8f9af7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d96c788a78d428c30602ea96993d420f6085a93727a68e7019ca80c11b958db"
    sha256 cellar: :any_skip_relocation, ventura:        "078c92e3c6befc82fda2990345c6a91da46e3d589488d55676b55b8ae1332546"
    sha256 cellar: :any_skip_relocation, monterey:       "548ef517e13ebd1f5905e9dd104dd79f0c0bbe34d538e2e7b3e97f6c3f284798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9860bf4f4b719e5e6327a3cef063a564e1ad2239751c4a1b42c2c7577278de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec"spicetify"
    end
  end

  test do
    spotify_folder = testpath"com.spotify.Client"
    pref_file = spotify_folder"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file
    path = testpath".configspicetifyconfig-xpui.ini"
    path.write <<~EOS
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    EOS
    quiet_system bin"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}spicetify -v")
    assert_match "SpicetifyDefault", shell_output("#{bin}spicetify config current_theme")
  end
end