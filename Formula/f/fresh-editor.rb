class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "5db0493f25ba864f90a006633c4b2d66cd7c5a08f4a03ae8ae4c9ef39e9517c9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2eeb468ccb2696a00150d6a9e5b7313b2402ecf302819af9c40fc7414acf962d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f4a67ac060cbc04e740a7bc238371e3beac11d342e7f4b2ff8d5bb6519ba00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71b539df3d87262dd59019fe3906083e35120ab31ebe59b7f1f55f26bc60ae3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b943a92793ff6ee3c18da46906ba66b44bcff28958395504ca5ce17590854b5"
    sha256 cellar: :any,                 arm64_linux:   "203ff4db716f93749d50cf75c870da8db4beca47beadae621dd56f213ea140f9"
    sha256 cellar: :any,                 x86_64_linux:  "269e173ea16eeedb75dc5ed9a4800b2a5df089e20a6b72ae745550124422feba"
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