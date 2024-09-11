class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.38.3v2.38.3.tar.gz"
  sha256 "0a5315940f2d193a3c22ccf6e244ad1917c87a1a3c6f00462b7deb5333d24a0c"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c6aa0ccc801aa87dfd16252d8bfea695af7b3272bc59c225ae194986fb38e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c6aa0ccc801aa87dfd16252d8bfea695af7b3272bc59c225ae194986fb38e15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c6aa0ccc801aa87dfd16252d8bfea695af7b3272bc59c225ae194986fb38e15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6aa0ccc801aa87dfd16252d8bfea695af7b3272bc59c225ae194986fb38e15"
    sha256 cellar: :any_skip_relocation, sonoma:         "df901a10cc518bed6dbf1527d5c17733c9b59eb789e8ab2eed62863b26cb52ca"
    sha256 cellar: :any_skip_relocation, ventura:        "df901a10cc518bed6dbf1527d5c17733c9b59eb789e8ab2eed62863b26cb52ca"
    sha256 cellar: :any_skip_relocation, monterey:       "df901a10cc518bed6dbf1527d5c17733c9b59eb789e8ab2eed62863b26cb52ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85dfad34cbdf5d815f8329b2e6b95716edc0600f1feedeeffbe579a360566458"
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

    output = shell_output("#{bin}spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end