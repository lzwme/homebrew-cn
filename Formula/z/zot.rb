class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.42.tar.gz"
  sha256 "b28bf2e1ffbbb69b4eed8c8914bc6c8ac6a82629d912f0832309f85d25adef0c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5772f69eb0cce6cb0c5c9cfbb8551b0d66e0938273133d508ac15b40ff3786fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5772f69eb0cce6cb0c5c9cfbb8551b0d66e0938273133d508ac15b40ff3786fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5772f69eb0cce6cb0c5c9cfbb8551b0d66e0938273133d508ac15b40ff3786fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "46832d556fb0f6d98c30e1ac6a4f9e232cd431edae92b4dcbc31d3b73712d546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14e39a5ab264a359d4f4ce577758efa378e8d4da4c886d81d686f720444f9cb3"
    sha256 cellar: :any,                 x86_64_linux:  "1b80130da0f752875cec852b8b0141d8152d7404c32572d135125341ea883442"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end