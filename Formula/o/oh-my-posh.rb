class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.4.0.tar.gz"
  sha256 "43e73e6cd9d680aad7f86ead597b8ff0bab20f8a707fc0e31c6baaba131b8749"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ace6a233acf0d77af2eb16e81649f4c3ff470b64fd7e6a3d21a0de4f7e6b7149"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d2c4458cd6d43c3ef9b782ca2c45e64ec6f54990b5093dd40d3113dd11cfc1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97a0fda2aade39edcaf142b04b073c933eac462097c7db1df516ac5de4346149"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a27e1bcf5c55239316ccd60086278eb466e912eb2533ffa087d34a26d7531604"
    sha256 cellar: :any,                 x86_64_linux:      "6a834f31f54599de8deeffaff101ce11ff7c321a9b97a43f922c9e4260e95939"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src"
  end

  def install
    ldflags = %W[
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