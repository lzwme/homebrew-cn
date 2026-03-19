class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "0905f0d7e8b71c38da7dd99b0faffe3fb20ed17041fd7eee4102caec25295b22"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae04a7d382163bd345653c29702c8b4650cbd988cde4395a26984fd588318432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc7876489e85732f2e0691f1ce2682ada13364007703272a83f06a63600a411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa53c9dd17292ef1ccbed91aaefb1233be3c2e2641948ffb0e1b553b81ddc767"
    sha256 cellar: :any_skip_relocation, sonoma:        "2222225594bc339360be9c4220f8cbd4a43c694e9c323165a2648f235381f728"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcef539cc8ba4841218e43bbc52b88284af01a1ac4a46e32f9afef0b62dda950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4394d14be3d5cbb56fff356e3100736a948e4022ae8940efd20654d197f41784"
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