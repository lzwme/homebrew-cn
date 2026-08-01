class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.29.tar.gz"
  sha256 "c4721c4884dbd1093a3386fdf5d752f6630411bb54d788b7c4e7f1466414fd57"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a5855bf57a79e5c349fdcee40e55303c88178de2a72793a11d45fe3b6a95501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a5855bf57a79e5c349fdcee40e55303c88178de2a72793a11d45fe3b6a95501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a5855bf57a79e5c349fdcee40e55303c88178de2a72793a11d45fe3b6a95501"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c8cfeb2d9bdf74ce3b6464bc4ff0f67f651c75929c849280b512313d9d11b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fdbfc978dc9298796df8050f17b5eccee156470bd3e987d458d3fbac4c8a29e"
    sha256 cellar: :any,                 x86_64_linux:  "644cb659e8728ef2210b91c3baa6a5326310287913e9dae342cc42881a87055e"
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