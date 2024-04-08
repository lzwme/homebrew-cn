class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.3v2.36.3.tar.gz"
  sha256 "fd8218087d42c7ea2aa52958092ebf239272b6a97aaa37dd21b1707454ed1a33"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8be2bc696bf80f7d03a65afeeb76555d21bbba864f0ca81e0d4d271ddea6271"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86e2bdab336dce7c75600d3620bec826d7014cb4b73b2ccff7e3c5c244e39933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6df330c0905925b3d5b839efa35b2eb2a9023dc8536682cfbaf7c1e7d40789f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "aed31dc2620114e130d04061b29f4336bd07a3ec3adc6b6dc70d2d6480bd6ec6"
    sha256 cellar: :any_skip_relocation, ventura:        "15569ae8f70198e1b85775ff8ac1fe8d762c76fc8fa040cecc482d90bc8bfc0b"
    sha256 cellar: :any_skip_relocation, monterey:       "8ac9dc72b113daf3461270b6e2570a001511e65d126c697b2450cab9cb2e862e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17647c1eb0ed6277ebd6b630d9209e5150c104e98367dd77c6516938b005c320"
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