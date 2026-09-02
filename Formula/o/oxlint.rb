class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.81.0.tar.gz"
  sha256 "29431517f760ca4c6ba58d4416faf306bc9fceb0e11f9889a85b674b1ea34d60"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1189f9e559bb65bff681a1f00f51bd5d43e808c52d2836fa75610b6a23c2eff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebece297514770a949975d0f0b8e93a1df6f92c1650d4c0e2d9ad520da985c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d11836e0bdb45ec5c2be97ce1c6e563f742f54799a7c649d7b3327420beb52d4"
    sha256 cellar: :any,                 arm64_linux:   "5aeeb2f3d1534685870c6fd6c652161e394f158c187656fd43c29fa4a08a7599"
    sha256 cellar: :any,                 x86_64_linux:  "beabb4c9da02d193e4038bb9da897c4b36429148e1c8852473d67b5a8ad1539c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end