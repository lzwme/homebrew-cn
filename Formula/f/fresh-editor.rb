class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "924b8d9bb276703e164e064c876b849815a44443fe4203234a22cd607f34bc7c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a697734ca78561d1fb9d2b8f8499efc4a0d322d1f0e4e56735c4c23f1cf086d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b66fb0c76f104781453dacbf0958ab4a17ddf26c56a90767454465c5ffd6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4f02099b7277ce168c38eaa76ba2b1d96c28469411fab59367fec3ef4ded79b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9330aa8e83c4924bad02313f7986a556a845bd11920e8532536cd10514ed244a"
    sha256 cellar: :any,                 arm64_linux:   "1fb01a11c899d0202aca409a8193c2c2e74bc9b7f546df87d0fb0d2213b111c5"
    sha256 cellar: :any,                 x86_64_linux:  "fe76c9f06741dcc362c177e8a2b53b275a3031d43adf44b9f3bc43847d279afb"
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