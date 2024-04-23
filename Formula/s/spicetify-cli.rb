class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.6v2.36.6.tar.gz"
  sha256 "6083f7eb5561252d42d01e781208a9d1b8bfb89e6608a6b091689a208acb7767"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fa0b393a2e5dd24d367e32acb109201e9639a1775805db662a4a38de48f9e16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ea72c124a5a350de13a57a7abeeead8ab39d9cf33dab338a86edb1f70fcbc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "227883dbb844248c7fabae3c3b060278ff8f94560109ed764dcd3d558b580c95"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cc96360392a5e868bf2e3496011f71df461199c8627c87ee067db18de553e16"
    sha256 cellar: :any_skip_relocation, ventura:        "966f187d9cf9f57f6e8c5b9a440068df7f65482e277ee7887d445dab96fd3c86"
    sha256 cellar: :any_skip_relocation, monterey:       "b499b916e4aa63139540ab18f8c8836f9737dfbc0bbc263f32c9d22203079c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f358f4b080c3181d3de3772932cb6abfde22e90ce854dac9c8fec61e42001db"
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