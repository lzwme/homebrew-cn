class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "6c42ea685f0b00130466ad97f352ae7360cb44b5c5ba9e853c4a157355029b44"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f270d2fe3694e3979546dd9900aa9c958441d9aa12fa8a50edf6fb936daaccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e426e7cf9811501460e600e92a11f2764bbd639d46290260c7dd5340f4d1de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87611ca9a0a5c8330a0d5e2a48e04568801dc8be0cab19df44fcb1598b8b6768"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d6a25ac03b78705df8be8d2c2bbe1b0750499b5dd09077658a4e8e7c0a97fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d36ccd9bd86e3c65afabb55e45b4a279079130e74c1d9e1b756ae6d99d24b1a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab8a43e796ef50ac05280894b730cc778f8af76f492bd22cdcab070dfe0cdc7c"
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