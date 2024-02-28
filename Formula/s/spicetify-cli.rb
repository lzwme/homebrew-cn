class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.33.0v2.33.0.tar.gz"
  sha256 "7e41e5555642a0fd2095804762d394ebddd3c850407e4c16cc6d3e55caa09ce9"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "188f98c29cc7b960f07b6d40e51d20e2ff1165a9f029461f7012dfa39cf96fd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bcd4bac37ad7b8c1a5b3170cfa4832d6a08e123bdd5b8666ae26767a8eeba7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c136995db50f83db9f2b8d1a9c26229428330b3058e4ed4afc562af5f839e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "75bf0e4b282d022ff0f085d73f8db382e06d61922f38889d7d96d39019f9f356"
    sha256 cellar: :any_skip_relocation, ventura:        "4b86e5380ff4e3038c6759b7ed634f09bf7658aa91bef3b754bbb13a9ec15da1"
    sha256 cellar: :any_skip_relocation, monterey:       "af705e30c6462dc88840e22d944f75cbbeee6c443508d1b72761d44ab34685c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03df8242b0cf92c56d0f7a41c6e5c28dad3bf4d93b8664df3a67387ea5e9549"
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