class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.97.tar.gz"
  sha256 "12f4fa4bee27306ecb2bc12821f6b03d1200c1d70dbea4d2a9643b9dc7cc2927"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07b6cd56fefa100beff4ea54e4ba72bcbc78936742cf73b65d6df08426fd8a19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07b6cd56fefa100beff4ea54e4ba72bcbc78936742cf73b65d6df08426fd8a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07b6cd56fefa100beff4ea54e4ba72bcbc78936742cf73b65d6df08426fd8a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "095e9067f868f9879e9e81fd0463a3ef7aea7797746bfadd8a32f0c47785a753"
    sha256 cellar: :any,                 x86_64_linux:      "b07b932837299fdfb7b0feb0d77c6b36083c4fd59a4279518d432077a27ef0b4"
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