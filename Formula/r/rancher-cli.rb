class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://ghfast.top/https://github.com/rancher/cli/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "77ed5b7cc5ba86962c241ec6e96efc48871c115ee04ec180e43f3b8a44c59973"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b29df7e04bf46316454d218d9ece889c36b09733b4dc2bc37c1e290c9554f0e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "138c7f24cc72b22ce61c56eb4ce9fa045470901fa69b6201af3d008100d94a44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e174cd4ca9c501fe76536b8ede6961a0d806beb96d0f9b3ed6901eca6e3e7c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f100d552c276679fa1da2122d2b4acc7e190e8ca798a5dd271ead646ac1c715d"
    sha256 cellar: :any,                 x86_64_linux:      "fad776487e4d435a3ecd5d5a97bf3a5e7680188ce5c9e77ba3d78a0d420c2eca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end