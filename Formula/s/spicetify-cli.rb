class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.41.0/v2.41.0.tar.gz"
  sha256 "7a3e6ae327753060fac9fa0686e57b871ef92598752a1314ef0f5b1cde571230"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "693d3cfa9cd4b1e9f01fdbc35b3bab8da2b205810ece6faeebea5e923d5a4f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693d3cfa9cd4b1e9f01fdbc35b3bab8da2b205810ece6faeebea5e923d5a4f22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "693d3cfa9cd4b1e9f01fdbc35b3bab8da2b205810ece6faeebea5e923d5a4f22"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ad1c57efe6b1dcbeb3e178608822b29a821e176a19275e0b9d6d3885862ed6"
    sha256 cellar: :any_skip_relocation, ventura:       "40ad1c57efe6b1dcbeb3e178608822b29a821e176a19275e0b9d6d3885862ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85710c87fbc88a160aded8c27dacc23feffca96a3032276029f46dc49dafce8e"
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