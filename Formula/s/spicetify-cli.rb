class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.31.2v2.31.2.tar.gz"
  sha256 "acbfb58a9e6d2c141c9ee9f75d39d7a2736bb919cd3742026f8597eda68429a4"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf03e8c8cb8cdefb9a7fa5669450543dd341cd61b9a04c43680bf3b0f7b2eb38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b619e707708a12d8ff6f22a13b20476f2d789d36010ee4f65651ad3898036635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd534b73fd804e94b940b5df10200a877c88f5aa18eec88c7f5aa98391ee0f6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff435b8c063dfc0d4b794782baef6234e6bd5898c53995e57f1cc7a202cfce8"
    sha256 cellar: :any_skip_relocation, ventura:        "ef0327d0a4feb8bbb98faa13ee4f06177722ebfdc5024ba492534aed677e86c9"
    sha256 cellar: :any_skip_relocation, monterey:       "7bedc0d2cff5654162188800d062abc77e8a63a345eacc5b9359c471b029fad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf215a5aa6fa7bbb36726517409e3575fdb02afda5e0f377b489377224632ce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec"spicetify")
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