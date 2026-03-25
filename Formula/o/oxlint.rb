class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.57.0.tar.gz"
  sha256 "c15fe714c408aaf3f46faad912052e767fe61d1d7b7198fd1067f4e93048e2a4"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb686666fa403ca0548961b1093f06caf6815db222dc3c87a7aaf1125656773a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea907eebd7dae2da89d4504e77ec7ccbc6ac4ea237d0f8a4c5552be22cbccb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "961fb7584971714bca8a094befac594b9ea8612566952852447c3705e8e5a8b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff425acfe44c487827c050143023b326bc795476e765ed28d480ffd6348c8636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72ee79dbd54b8cd68361e0df1b2abe76ede2345113d0394de280af14252f2439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc1b710a8c2ae4605a18d73f4b21bff04d6231ab7e4d0d49c22c9a889703ca7"
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