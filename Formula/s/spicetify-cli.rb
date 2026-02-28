class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.42.12/v2.42.12.tar.gz"
  sha256 "bae2766ee6682ce8aa76180affce8d5346afb5a9b1a81cd3831cba286862bfd4"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c594970916598cb67ba1c0697f78e7d22e1a20f889643bf42edf61edfaf09c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c594970916598cb67ba1c0697f78e7d22e1a20f889643bf42edf61edfaf09c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c594970916598cb67ba1c0697f78e7d22e1a20f889643bf42edf61edfaf09c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0639be1fe80aad2fb21e53028832c12ca5c87eed56fdfaffb033bc4517eb2a1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5089c5105436ecd1ec13f820d88e7c1e833aab831c93e89720fe1a85918c3f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdeddb5ecee2d0d19bf99eb8297802b3d66982a271865b76e0620ec6951df553"
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