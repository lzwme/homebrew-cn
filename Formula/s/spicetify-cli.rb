class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.33.1v2.33.1.tar.gz"
  sha256 "658595fb23175d6e9c7ebd73ea50cf7551cfac5607f1bc91cce892e34809c827"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc3b896abf9bfd4de520717b191567675957fa691b45692eeba0216907473a77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb350d13298e65a80af1a22c8991f1bf468f1430c5a0aa0bdc919c26c89f99d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffcef4aaaeee284f76b9e892240121145ce53015a104e054cb5fdbcb590169fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b8b8ad74d9d1430e06277a145d12a0c1b347d09c0c206b897df6b5893f9ff73"
    sha256 cellar: :any_skip_relocation, ventura:        "5672609dabba6688f3d9ce4dacdbfd7e0fadd1a891424d22d614e98be9169842"
    sha256 cellar: :any_skip_relocation, monterey:       "d1829a6799c9120afe1687c3a3880a22ce27289019bde629d3980a9638615cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec282b7b551d025a499c4bb002d999c9c1a19b8b989f62a912803a494e53a54"
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