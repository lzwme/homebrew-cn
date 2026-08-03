class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.30.tar.gz"
  sha256 "c63dfe39d040420b817cfb57d2beec06a9ba818028e88969b1991042d6f42ced"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b894d709838f203ba2ce97fe81c2fe2ddc1da1d8ba9919736ce3a4bb54f9f352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b894d709838f203ba2ce97fe81c2fe2ddc1da1d8ba9919736ce3a4bb54f9f352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b894d709838f203ba2ce97fe81c2fe2ddc1da1d8ba9919736ce3a4bb54f9f352"
    sha256 cellar: :any_skip_relocation, sonoma:        "e120917474d80ba6940278471045733bdf1fbc73d2d14869ea762a413a193cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c8049a7dcd3554faba09c88a18408eb47a51a143972b362b2e8396cca1fd30"
    sha256 cellar: :any,                 x86_64_linux:  "02e7a5764199579dd12f0955246a72f8dbeabe1ed344b00e26d661882641d2fa"
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