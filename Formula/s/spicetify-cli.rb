class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.42.13/v2.42.13.tar.gz"
  sha256 "4e6deed25d42f2f5b42cf70f33a08576c4e052f2a10f068a9def7a36513283ed"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c1bc20c4a20246085725c2276197e29f4418358aacbda1c323262dc7e8f064c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c1bc20c4a20246085725c2276197e29f4418358aacbda1c323262dc7e8f064c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c1bc20c4a20246085725c2276197e29f4418358aacbda1c323262dc7e8f064c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8930bac07876c6be24b5fa61d92fbca3872d83b2f9c37c5dd6afc7f449755c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da6cf099c356c996622a5920897e578973aeeaaf4a3e14f3cd501258bf61b9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a4641c93bf248bb73d399489bd088785acd3e3503e976fd6e3e071f7008f826"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")
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
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end