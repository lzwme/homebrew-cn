class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.42.4/v2.42.4.tar.gz"
  sha256 "f83c0749b95cd2bf628f34c83d0eb9b29bc8a011df92b832d78211276d214ea1"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb7cd13cc44ceac5501b04327b8f3cc538bd234a24d93dc819ddf5939c2e13e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb7cd13cc44ceac5501b04327b8f3cc538bd234a24d93dc819ddf5939c2e13e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb7cd13cc44ceac5501b04327b8f3cc538bd234a24d93dc819ddf5939c2e13e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b061e0223849ed039ca04d5e1932d6c863aabcd80dede5fb8ef7ddb59b3782bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "661d76df3dfa27361cc1797dd622fb36715a15222246da57a2b444debd44f65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1419b0836a8e2866e2a9567a701bd2ec4bc809f32a1217b93bc2a3c2bb2ae42e"
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

    output = shell_output("#{bin}/spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end