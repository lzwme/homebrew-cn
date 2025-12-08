class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.1.1.tar.gz"
  sha256 "6cf14167f33245b3aac15c1639fffb499d3d4171d050155c958201d2c81f4f51"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a535fc04e4e8d3d972caebf57500eff807210f5df86e3a4ee2ece04f5b67adb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "966fc48b617223bc00f5adec5d4f8787935f9a5c4db7cb23ce053c6ffd26d189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f6244933cdb488d6c6a51010dba81c6a8deb59f8843a0606051a8d9bad3476b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21bca6cbe5a855bfba19c63d1aa9ad310b25d38e17f1f897419c36032a95d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a767ec24361aac1806e718db03e564ed65f4195324c69bddcb18cdc219461495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a6850b2d581075ae1e2646d560db7506b211e42a75362d5e6dc21f0a19ff0d"
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