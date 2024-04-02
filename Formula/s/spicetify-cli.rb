class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.2v2.36.2.tar.gz"
  sha256 "d631ab3e8ac2725922fb686a22ebf6c86bddc55974311cb1d9ee438278670c62"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5964569080aadd5f05761ac07b53bd8d026b44dc7b3a8283a60ae9e60826ed84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "753400bc7212771cc5f1be0f3dc14571e78dd21a63590bf9b85f358c60590d72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f441032152666f736a93e96b6f999bebcfe8f769162960d7c35bb0a5a8f7787"
    sha256 cellar: :any_skip_relocation, sonoma:         "a20e1a538e61e90d51f3784bd7f2e6438a0d02e2cf5842f75eacee634a0d0b70"
    sha256 cellar: :any_skip_relocation, ventura:        "b7e8bdacd696f8bbd052344d292ecef8c86bc063d90af92b67771ba3b7356ace"
    sha256 cellar: :any_skip_relocation, monterey:       "2f9fae28485fb8a442bdc390061a9a25b99c64c0ca3865a2b503155869cbac7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104a738efb41e1b2587ea6d717196d2b68edf93ee682811b3a0d1144852a6c3c"
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