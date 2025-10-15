class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "8a33eae71f6296a6c8b3630a35bb04f5c42c8fc8467f52e3c52e1d1c92904604"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72e7fca8d52b144e86a1d1854923bc64a679332ad2730d60800e33f67eb0e05a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "415b1b089b1ba9df15786079017956aaa32af73a39074aa3c8221f93de538b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ec4786f45632bf8c1c89ed06247f910ed815abd25579c9e4c6a15a890f7800"
    sha256 cellar: :any_skip_relocation, sonoma:        "52de56fa8adc3d049341be0a1a2cab912eefd0aecada77e917d093ccd8202079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7c4e853edf7603c8af376ad7cafc43b0960d8025dc015179cd26e1967d94fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d17a581127e7e23976426ecc6f373cfc8fa127e113ecec1947d8d7f7c84ccbc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end