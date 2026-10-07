class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://ghfast.top/https://github.com/fioletoven/b4n/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "dbaac1beeca8cda7f82e1d85f089f259821c9f60099fc88f62eda0e1db0fc3bf"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3ec05b92ff9124decf949c337f3c862f70759e099ac428599d5c1a177cf4376"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a92cf06be3984e77fa67047b025f1e1b3fe6c9a092125dced44fea7d7f40775b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c11b5801c2cc4b482f21e00e72ba576ce0836f13a608ce69d860d2284dfe7827"
    sha256 cellar: :any,                 arm64_linux:       "bde1c5415b8d8a4ba28ef99a74e74ac8e7e1620643dd05f75e55a32110c759b6"
    sha256 cellar: :any,                 x86_64_linux:      "6d203762d6954854751c8e8b108f09dc00304848b86857c65f5ef7bd89a404cc"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end