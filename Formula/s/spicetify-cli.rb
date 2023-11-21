class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://github.com/spicetify/spicetify-cli"
  url "https://ghproxy.com/https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.27.1/v2.27.1.tar.gz"
  sha256 "3e41c4ac65d916fea662037a492ad63490a22255fad7397731f8fb6efcb3cf0d"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/spicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f50e1bb26289e70c0fc179110b3d93de53d8b60583785c26882ba2117b266e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f06d26f99b502efed9fd568b5caf33f603e5b101257cce2de0a8c81491d46e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "711556dde2b73d017b6120f6d3d1a5e5b83991ab6d9925cd8a0e5b271deb8136"
    sha256 cellar: :any_skip_relocation, sonoma:         "3686ef6e0e4b020fbd28a24afe524570e57b3c3c40de427e9dd7b5ce7a149550"
    sha256 cellar: :any_skip_relocation, ventura:        "a04b1d05b70de1c31e7b9131417a7430114b5343828464748df330bbd6622a7f"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b4c99ccc588b2d39b28ab770c91633e4568ef90a1e3283566111b915b7a41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "478bb40fb690b5debf9501292acd60585cb0a3555e49973c77f5ec5381480fc7"
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