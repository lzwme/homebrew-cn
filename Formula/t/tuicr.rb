class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://ghfast.top/https://github.com/agavra/tuicr/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "80eb19ffc369d80ddc02c53b86297694c3f01fd938907836c6f82c1134aeea6d"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "becb0b2b55709b42a1573917eb169024eb4fbeae4ccc3432a2b9bee6eaaa237e"
    sha256 cellar: :any, arm64_sequoia: "9122c16b0a827eb86b4e8f0ca6432bdb7b02fee3b7e6177c0cb82750a22a8a2d"
    sha256 cellar: :any, arm64_sonoma:  "d94ec2a4cc323e5d839d4b4cc47f767517385d079f30449302da4fa706207b29"
    sha256 cellar: :any, sonoma:        "191ea3c14c3367da1094fa4d803dc0bf2885baa33b3c2315df93e97371f3d3a5"
    sha256 cellar: :any, arm64_linux:   "1b08edb0e0c933e103f4cd519aa59447561aaa7c2989f1c9b475cf4ffeda6893"
    sha256 cellar: :any, x86_64_linux:  "dd7885599455becd61ce3acacaa9bb02dc6a51d8592ac20e7eafd10cc8bdc48f"
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