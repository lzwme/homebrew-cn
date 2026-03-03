class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "b9fd5a828f0af95fda3d8e4aa69b08d81ef6f66d8adfc3dcb2870a765b1ade96"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6e417411e702dcb43fdb1ead2d1b76eb78ac50fc3058ccbd471ae42f0218bed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ff2e88196333376561b7e954c371800167ba9b98d17368d7da88f56958563d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33817245f4b0daac3c07601662abaa9bab98e470d21c117094e680bb3fde386c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c3fccf5cd6f62afa1a563a556a6faebb4a04bf8640bd188ab908b278c80686c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed15f5c36596d5a263bb780bb514d4569488267f81a02b50e84377e91c5e46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f88bb6c80b6bac5e68991c83b8f2baea625b0d16404351074e6982b382176f87"
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