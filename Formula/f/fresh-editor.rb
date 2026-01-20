class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.83.tar.gz"
  sha256 "3d77e2ed54b95f9dae16bb31e7286517f25a27538a2fe568cdc40cb3695abb85"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a4b7e7f5abaed7bf87741e5c5b03eefb92c7b5a92dc716491511d404d5d16b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88160548bdb7f724caeabf7e199569add74077b744fcc66167786a1e0549263e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ec785a4696900dbd53ec38d815e9b7a6ae307a6743105c3d62bba12c4c1fe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8840eab39a376aaf07fc3bb77b083aa41127580c6b05b3dbed7de4d296d236c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c4d9fdf6c253d05863af6fc6250109b41f0dfe3a3edff8d176792960661b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7e8cc9b031173117070d20a1cb8f192d4bccc0fcb59a936e0c0353023ea259"
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