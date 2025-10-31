class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "607e322d13cce89da43ea923dfa48c1a5fb10649a0de0300a366292a931211db"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9830aaa341d22646fc266e3b85c5b0b3b2eb6bbe31db56a30fb81d253cacc415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bfc09dc7ca3378ac4e15cc11a28fab44d1ccbcbaf089c994ef14f89a1e84443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80762e852892a445fd3d328e30e463fe11b1e9eee48586c349ab839e81754ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bbd7181ecad4387de4d43e4d41e1836b806327aa0b3409f90074aa6e59b8b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1fc2f20761dbc60fc0273c2efd1e937bc862df751a3cdea5bce387909a6733e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb2d30bb6615d75ed36470dac862c6d9ac48fc4f89a9e2c153be5f67e182cc6a"
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