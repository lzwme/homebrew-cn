class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "f1f0f31d629b16f954555c7139ad6f1115604726e8ebbd17b8909af0cc689b79"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23e0466f8639572e9ec26be17ad49c4260c0672903b3264ec06b35a730d817b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adb8d68daf98cbad3ae7d16240eaa9d9cb86eb69c8b01084047847b6867918d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e812c215e7a077fe8d64b07c5f2ff1b66794ce0ce8592193a42aef2d4732b62"
    sha256 cellar: :any,                 arm64_linux:       "46cd41bd8784a4739942eca8005ca7ad30f887754cb5c036020d9162bc506a40"
    sha256 cellar: :any,                 x86_64_linux:      "e3fbde3200d3e6e02d04e73a3344fcae8d753d19d3ad73abd20b3ce72bf0f41a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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