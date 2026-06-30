class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.72.0.tar.gz"
  sha256 "a374f545da6a64f5bd37cf575caa61037b80bbedcf743a6172858bbd0c2468ee"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "898c970fcc441083a599eb790373688e23dea6785ba7644a6fa3b1d7729cd156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2078ac6c655ee9c154b51a8ece86820d445e10a0cc31e880b920c83262460c8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1900c0445b40e6118994cd754840aa93a11b838996ffccb4b91efeb339015cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d49a95bca16163118872ff4721f0f7e93fd4c0b8deef0cbf5703caaf2c4cea17"
    sha256 cellar: :any,                 arm64_linux:   "3546840a84165e6957ce71f404f957e7a7ebbe31ba407129d5a1a41c8edffde4"
    sha256 cellar: :any,                 x86_64_linux:  "f609be66e3d00913a79d2d3193268bb202f144c144f2b88a905202d3ff61b8af"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end