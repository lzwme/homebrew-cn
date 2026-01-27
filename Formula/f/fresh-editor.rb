class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.90.tar.gz"
  sha256 "ed8c9276ef755cb221e87a094f93f4538ee5a8a585882e5547497143df815084"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e75bd43c715df4948a1ccd0f421ab94cdf926724cea92383b045121cca25220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6e7837ce097d3abea5d66c201c95adafadc5d3a8d457289c6645fa29cab9db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04b2d939d93e236fd0c053236b64ec59f1dd1284d06778ef908aa37ddc694199"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a6131d81a54bd88b7c3198bffa45fb674416b88ef2dd2f2ac9e6801875d8de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404973dd2e71438effff065e06fbc2e85f7b7afe8e3e533a1102ad5a042d1254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab595a895df49b42dec8ece1719091e57737f55d0d2c7d6e5ab53dbe41133b5"
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