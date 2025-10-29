class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "bb5acc01e0e71ad00310f6a837f379e345f9e9d74f6dcf45deded792ec3d60af"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a131e1d5c1ac1d547b8ad52279c0fc0985dc0d86fae147070dfdd7c81bc122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a2c9d59b418608b8d08673b9538d33687c6cf3e91cbe7ce8e037e5cbfe5b35e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "748429c6219de1ae54cd8448ceb5001ce66841c64eb214a5a79e9619e5325ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "026c626fcd154323e2212750e27d14f83501801f49f8c69c1718f1376f95ca26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "340b947e6581cbaae14f11023b0d07562d6429dc946398956e22aa25d96bde1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675cf09dee1314ac6515bcab85b0e6f2071cd6b59053c6b937e699ba6499a97f"
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