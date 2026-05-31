class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.24.0.tar.gz"
  sha256 "e382935e7c944fc28ccddf1b31f40ee3719e8a35439aa7821d2950bd42c1b2a4"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77da32e31ce1b343a1d08020a4ce037f03bcdaed018a1660ab2f500dacf37bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88e34c31b233e9acbaa309050fdbd567cf0cd1a459ea5a1cd93d656cdddf6759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa499274f0b8d3f156e790776d297cdf8a82c0a47fb8bdd9a42a19276b904b25"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb2ee1031f1ea162a8b9a94b55dfa110e4e0c40b17a31cdc449125becb05dbd8"
    sha256 cellar: :any,                 arm64_linux:   "d537290585ebdaff62dcb462788911f6f9eaa2ad815edb87a918e026d4d368b8"
    sha256 cellar: :any,                 x86_64_linux:  "133e440e17d7d3b83b1e28fd3da782dcf1e60442215260a5c0e328daa612c41f"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end