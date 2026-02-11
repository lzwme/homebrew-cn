class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "a5eb53e8182761e8e14e4c89fe293c6f52bfb61b1c97e5892419438436b2d818"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b9a2ef1bf637151864a00815f00ae78befe454ca5549ad069a231b4671362c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa9c5658096a9dcc2604775bee8148be56556fb5ac8a77099c364776b0f91101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869434390ed3f1abb65fc05af0a118aaf045556c77dccdd97c87ce69448dc3f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce9dbae4abfe4b2ec11dff0a72615fe96847ffe36307707c7004d74e541020f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94f5b755d97037121f2b6d20696babf8b3c9bb409f7ec291455ea5dd710b0b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c2a210a6ad7ed5b6e42d4ec091aadfffdd030351c5bfead4cff9e9631df073"
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