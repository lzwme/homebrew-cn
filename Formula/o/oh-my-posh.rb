class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.4.1.tar.gz"
  sha256 "0516e3cfda5d65a8beceab762151f2d6b07d08b085c2efd077a71a1281eee2c1"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0482ac3f091c79d3bbb490ac8a7327c6598919a96e503bcfe8107033fc571772"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3b7d82e7c8f1e4f78a7155e532338abb4b195286a2296b4f9f35eafb02f2d77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "681baee67b55a528a4685466b07c5192a38834c38f94ef1cce5e6f19e9c7b418"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "92df527784b0182e672dc5364b80fde05cd79ea1d1c7423abcdf1c1a30f5b4c5"
    sha256 cellar: :any,                 x86_64_linux:      "763b8cf0754fb14ba689decbeb5b3eca096b9ce56d47580babaf83d051ba1f56"
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