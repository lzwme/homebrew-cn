class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "428690fc0eeb08f6f8b8513797a02ff6f623bec33942b31f46ccfd1750f7c953"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5637afffbe219cba7cbf4e76d5204268022a4951d811f434c206f2e703168980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59ae3f2b665aa4aa5be3f2a550de018274068fa9ea652ee14643a5520c28b255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "032b80d5a441d54f32b89247c4c817fbdac2b85b74df0817939345913acbd064"
    sha256 cellar: :any,                 arm64_linux:   "1093b48d2d4aa498481a64d0d62f4eaee9527840b9c8602cf7d1198315dbfa12"
    sha256 cellar: :any,                 x86_64_linux:  "b06f8f6d04b76084cea9d4ae108792f209e7a4eb871ea80358ad64364b69a09d"
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