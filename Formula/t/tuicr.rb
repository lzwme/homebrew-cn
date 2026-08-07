class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://ghfast.top/https://github.com/agavra/tuicr/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "14302174c37a8a74289abe5e06f7a45e5cc5e12b344195ddf0135fd3ec4fdddc"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6679e5471be8f04273304b6f6c43364a97155e90c723fb40b599a8762f800aee"
    sha256 cellar: :any, arm64_sequoia: "bbf8e22069a410cb48b2d28d7a0656c33f090f3d943dc3564ce0471958902d7b"
    sha256 cellar: :any, arm64_sonoma:  "3b027eb49ab3cd25e5ca9f1a12d56e0376978e5163869935a82496c69d13b149"
    sha256 cellar: :any, sonoma:        "e7722586964905d3c80f0c1d4eea53025eeb2fe4c4eff1ae8f5085b06e8b577a"
    sha256 cellar: :any, arm64_linux:   "88c1590b9a6407423d8a6e0fd35a1cb6692dd9e8511e12afa6b8c8657102aeb7"
    sha256 cellar: :any, x86_64_linux:  "ead06b6233c606dda3d1d5ea5f260c9ab8b44b6d1e65b6644a1d6be0d9f16bc4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "test"
    system "git", "config", "user.email", "test@example.com"
    (testpath/"test.txt").write("hello world\n")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"

    assert_equal "[]\n", shell_output("#{bin}/tuicr review list --all")
  end
end