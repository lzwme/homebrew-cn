class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.74.0.tar.gz"
  sha256 "709d5e091a57f9a5ad624cd816e49a24434e404286b10cdae80129e6842f5051"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cc84ee3618b8edc9543fcbc1e62e599709015e48ae8358ce4921e92bc830984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09d6b8732b7d017ef72c2a9e0e595820e65f98854782280f7c4a71365696ede8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd586bdb821131352c724d6391b2295aed3546a220413db6ebe66c269f97f3f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "64101d41083fc9f66927b0521be7b034b02e69dabc5079ebc93a74ff282361df"
    sha256 cellar: :any,                 arm64_linux:   "8ac0a104e765d95a9522c42292b60c4504d82c9a19006fc292cb07aa37486b78"
    sha256 cellar: :any,                 x86_64_linux:  "c574395b2e239bdebbab5bf00a13a666bdbe27da6011dbc1d4119be13fdeb4c6"
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