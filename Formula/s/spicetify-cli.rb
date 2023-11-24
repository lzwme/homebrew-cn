class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://ghproxy.com/https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.27.2/v2.27.2.tar.gz"
  sha256 "b7eb6608a59d4cb721f32147c2c0f1e5b66fbe5e62c09f6db02a98e676e383de"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "528300742d4787c388f39e1d06cf410c12277b25b98b202608149221155667bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba85f2d44c7b52cc7082f480b60e8437b2eabf80d708413fac583ce217163e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c1ddbe8efd34bc4fa6abfb7af591205da3095c98cd9c899d9d763d9560bca1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4edeec5ac182d09c75b861231ea265e871fc5582f16801db570d7eb167a806ef"
    sha256 cellar: :any_skip_relocation, ventura:        "78c988a9ee5a3a6afa0ec20211fe417d30034bc1a4a9875e311a8723b405536a"
    sha256 cellar: :any_skip_relocation, monterey:       "61177b8298d88db71a290e715faaa20c21ba70833b064c9089661dc09719d45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51802b5a823f344505c4b806015d5626961d1136288d9277c1ec6f2f07cbb8e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec/"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec/"spicetify"
    end
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file
    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~EOS
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    EOS
    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")
    assert_match "SpicetifyDefault", shell_output("#{bin}/spicetify config current_theme")
  end
end