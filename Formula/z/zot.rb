class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.41.tar.gz"
  sha256 "ea8f924bce064e08718c8dc8c2964c98d1de4c826288213759b3f87bf1ce95e9"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85408dc3bfd33df86adecde8d89eac80bdb4a83c15165ae43598fdf9bdb8a323"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85408dc3bfd33df86adecde8d89eac80bdb4a83c15165ae43598fdf9bdb8a323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85408dc3bfd33df86adecde8d89eac80bdb4a83c15165ae43598fdf9bdb8a323"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbc151c5871f0ba0953939dd8869e3db5c51c7537cc4b8d63224e559a582cd7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf319aff34fac1d75f42b11a5e0c8958f572505aec2a0f2c8a0066d592c55dcc"
    sha256 cellar: :any,                 x86_64_linux:  "1dcafd26c15e045ee3e118ed39f27573d5e52c1b37bc522bd27969915d76c5bd"
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