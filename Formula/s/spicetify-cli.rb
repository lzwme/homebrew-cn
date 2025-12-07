class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.42.5/v2.42.5.tar.gz"
  sha256 "d04d1f465da7a2972f6bf5a9ba99b4a4efcb8c57068b862b2f63d4eaa032f64c"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84d13aebf94664c5f87bf8a30b5b92fc2c50f3533a198b852692dbf33bd91e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d13aebf94664c5f87bf8a30b5b92fc2c50f3533a198b852692dbf33bd91e0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d13aebf94664c5f87bf8a30b5b92fc2c50f3533a198b852692dbf33bd91e0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "866dd20f9d039e523ee270efd8d231a089a3fa72c0126f6bf947fa84aff4d031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f54f64c4658bf319056ab722f96d52655dcf4611d1b486ac3ce635f0177bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2867f77202dd991db3a49546146932856291c157f92372551d58f18dbf7dbb95"
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