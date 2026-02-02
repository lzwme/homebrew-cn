class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.98.tar.gz"
  sha256 "f20c70b0a7e26d13e7ab8cae91ce249af249c60c214c4264ac43d1fc01f5d2a9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f06881a36d79cd70bce518c13b61583a30aac1d5ee5c024db7a5942854aa489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd9184adfbe17beb21630acfe77e934e04783cf7f3bd15071b3a4e4ccc3448e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7084d5ec58f3475b3cf94bd9b38844361a403a8af44c9abd4546ece91b8eecdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc381f3094a8fdb1513acf6ed54c558ba3a7eb17cc6d4f7770e2a3a1ebcf539f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb76afc3174b2a7391417dba21fe8f53fc5197e7a208c9f76fc003b726c4ca3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1618b2e0e78903b4b2b4196ab3275911c8daf09ba806f196e0df08766d90acd2"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end