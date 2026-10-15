class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.33.tar.gz"
  sha256 "9d96b6dd76339036074ff35664e2a7c90a10bc2c58f77c3c2320ba641516c3a4"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7925ac4ecb3d0c2999eed79de2b1cc1a0bdae0cf9bd110421a54683879f2328f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7925ac4ecb3d0c2999eed79de2b1cc1a0bdae0cf9bd110421a54683879f2328f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7925ac4ecb3d0c2999eed79de2b1cc1a0bdae0cf9bd110421a54683879f2328f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4bb5d058cf6421cd33061590daeac3d5e45f0adc437af30b02b97d62c508c40"
    sha256 cellar: :any,                 x86_64_linux:      "ea1deff89398062f46417ece6c13b5877f10e047072302ea63dd831741d19fd2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end