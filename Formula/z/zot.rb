class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.52.tar.gz"
  sha256 "4c4e0a96ca729230da2e641e20b535cce2fc3bcc50c81202ff1a32adc3a4bf49"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d3f49ee2d3de181fc276123dd844c49cba9f57e4bd45c2d66600d266b326bc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d3f49ee2d3de181fc276123dd844c49cba9f57e4bd45c2d66600d266b326bc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d3f49ee2d3de181fc276123dd844c49cba9f57e4bd45c2d66600d266b326bc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ae1c254dc2f897c81b6e64aa9564bd9b084d48f24562fd7d99543cd2ead24bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5a90b7a92f0cac865eaf99c075330f30c4d9b8ba2996ca69a817106dfd3a9bc"
    sha256 cellar: :any,                 x86_64_linux:  "fb6877742897079d7b40a83cdef7889f8b1d94ae71dc9cd0157cc2e3259024aa"
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