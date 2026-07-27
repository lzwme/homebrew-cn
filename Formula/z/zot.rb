class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "2ab6a13284d1bcde46e0eb1d9cda8b5d78b8c52ce944a2f5f2199b3eb54f7efe"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5caca3fc54c867f27f6fd2bae6b0492d365a6ff4fadcea7bee31b03b2cd4ae0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5caca3fc54c867f27f6fd2bae6b0492d365a6ff4fadcea7bee31b03b2cd4ae0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5caca3fc54c867f27f6fd2bae6b0492d365a6ff4fadcea7bee31b03b2cd4ae0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "11a11a00390d55f50cd32d04e6fa41ab3359a297af79153be52676da779f2049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "312904d6189733cd1a8996ecf65890dee2b34e40d0d123b484b0d04dcf24ee05"
    sha256 cellar: :any,                 x86_64_linux:  "57dc20b63d453825a4d22223fc0043017ba2cb781320213f2c3f07f2126b9266"
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