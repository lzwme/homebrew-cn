class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "d8fdd9fe1b137aa950652f3b600124b41bd7236ce8b083b0aeeec88933e7faab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ac9a3cb78978434a67486f02066e516754033357823b704eac3ca2540f2be3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bca57729e5338726255efdaf8908d208434e0214b3bb0f464a19b1c56a3c3d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0763530aa4dc9c3b7fe2c467ecf5fa4df3b4967c93502d6be8a8a062f7b8b3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e59ddd705405f6263abe068410752a5414167211e9acbfb58f8c7cec6d0338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcc3185edd6e186dbcda3aa4c20d5cc8d1dbcb8ed29c0905fadc0fe7236a3ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ecb912363ef18fcd34943f19350637ce43562d66b75eec8ebec570aa585cf3"
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