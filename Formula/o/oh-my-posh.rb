class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.15.0.tar.gz"
  sha256 "cc04a700761005a295204868a57628c04fbf03557d59e99e71f6adb0a0c54aaa"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d3802dd2a58acfd0b1fa5fae917fb9633de7e848c588a1acf0e55d287ddc526"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "221587faeb2900d744c1aadf2ced2a97b38b57179444ac55e6abe21f4415733e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2115205d40888ad02d2c082f0983dd96caf4ad7a1f71253cf3e6b1ea706bde40"
    sha256 cellar: :any_skip_relocation, sonoma:         "114f455abdf0536089191f6e7584846603bc43961dbd8794f5e3129f7a6e0876"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe60d48f714cb31cb352a43acc3994b8b9bc38614320801bfcd00bfc288a5ef"
    sha256 cellar: :any_skip_relocation, monterey:       "0bbccf05e0a85eb426066f180e5831ae816718600d576b0d8ffed044efebf167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72bb2cfa37aa394a85573423fa92b9f236412fbb3768ed4e3716c19e23239c3e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end