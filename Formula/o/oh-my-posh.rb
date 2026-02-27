class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.7.0.tar.gz"
  sha256 "2b8bac00da30c66aafa84f02a41e7549eddcb9b2cbfad54098e852b3591cdf3f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea6177d5f665b5faf34f6b8d1aafc407af9f9258bf31d70d0ce28cee8df82e77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c044faedd4d6fe124c6ec9a0ea0acee600c49a7df34752a653752a3e6709eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a7a494e0e143e220da1411ba5c1378d3849472c6494b49657322db015a5e4d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f9a903d6371d4c6432cf095217d2493f12145ef6acde52ea40f6dd694adb21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69746dba906ede176a73ff73c0b451338e3c366774b9152cdd605e574860d533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1615e0e6b52506890e378f6e1ae3b060a51d03009c097b04392cced5d9e2d0f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end