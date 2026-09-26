class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://ghfast.top/https://github.com/skyhook-io/radar/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "7e02a2ad29f3653dfea485bbab8934fcbf2b82045f57e7ce84871605f4b6fded"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9d3f3523592f1390ab1a9f1c4f62af98182eb9895571ab3dd2dc3e2214bde3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03971193f773741a244a2412b84433d972f77c01cd99321dabc515abe609dfa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f46e9f96da88d9f981899b70e199c505d1f8fb955fc612beec00fe7d70afcc20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52126efcf02cb7f917ea3f02308683a3ffd9413d007bea3fc955d2515ce5de2a"
    sha256 cellar: :any,                 x86_64_linux:      "d44ff54988f92031bfe3103f6e70ddf2dd55cbb5079bd8c3341e3476949ea5a8"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "make", "build", "-j1", "VERSION=#{version}"
    bin.install "radar" => "kubectl-radar"
  end

  test do
    assert_equal "radar #{version}", shell_output("#{bin}/kubectl-radar -version").chomp
    assert_match "failed to initialize K8s client",
      shell_output("#{bin}/kubectl-radar 2>&1", 1)
  end
end