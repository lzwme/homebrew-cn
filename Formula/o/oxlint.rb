class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.46.0.tar.gz"
  sha256 "61b2376852b231c42da6f42ca61dc0436eb3040da57f011fc7a6be564934fa84"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b5a1b746a7ff68cab0fdb41e88c74f09f5392ffc0b28084745033f8bb90b0d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3ae1c7aeb72252c8742c3a2f3364dc7b5007dfd79eb914c6e6f9fd262713cbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6175eced85571232052fce117c95c7c2434c703df8df756d343aa96c97e31ad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8147e53583474b0a03df89a2cbad666c951e2c1f419236c230c93e7eb7575337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5029daafaaaeca89a374756740db48517aa39131b92d266eccb821aa2f2d06dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdba5bcb23f2e4a357df70114f6120b36940cb2f5ea1dd80613b66edc155fd10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end