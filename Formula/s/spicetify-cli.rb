class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.36.15v2.36.15.tar.gz"
  sha256 "b9d761cde9a384399bcd8dc959aa7adfe3dd95b28f5ec2cb78f4f56957af9993"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "949bdba1f27eb6d6fc416f0034ccd323b6843aa16844d984cdcdcf1a875e8f77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb2e81ff1b6552c25d9ce1dafc8670d3914301891517eaafc9374dd8943df334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9564c3b15e59e788e1d96669647edbdb75240aa65fea1d7932956f6e482b994f"
    sha256 cellar: :any_skip_relocation, sonoma:         "93974fdb8d5592ffb55a10149fb4c01f624a7c79026c1650421fc8dfbe4cc1af"
    sha256 cellar: :any_skip_relocation, ventura:        "dc595f841eaa4dc05739c26fc1024bb4a1b76f84ebb3421aa414b5d7298501da"
    sha256 cellar: :any_skip_relocation, monterey:       "7495931501d8960abb525a832d95c8e0f11ca6cd3f00f1fb2456e331f62a4b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8212d88195788c5a2bd32b612738b3d6ea209f9954275b848f76b01d78d3efd3"
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