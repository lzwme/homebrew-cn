class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.34.tar.gz"
  sha256 "fb743fc838a4a5ec9beb549ec98c73451742ed05d6989f4c4e8837cdec9cc05d"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd51ca669fbc2aba69b4090039aaf75d84c5b430bf2c8eff4c7a2d45d8a059d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd51ca669fbc2aba69b4090039aaf75d84c5b430bf2c8eff4c7a2d45d8a059d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd51ca669fbc2aba69b4090039aaf75d84c5b430bf2c8eff4c7a2d45d8a059d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e0d3e431de25a9321391ffaf71adf1f491f2b8b4aac0349f0cf6a70ed55a4ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cfbce073239a96d4f9cd289691e106d6f3e3467ec78108e03ff46b22d5221ec"
    sha256 cellar: :any,                 x86_64_linux:  "61f0f237ea081bacce2109b242887dbb4ac579fa70ab6734db05b9df1a98d806"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end