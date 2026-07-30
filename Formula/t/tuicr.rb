class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://ghfast.top/https://github.com/agavra/tuicr/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "329a83ce4799672531ddfa4cb0564163393a94e1a13e9bbc305c6f721cf741ff"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e9a4021e73acb5ad3d5aab39258cf9fe06f23b3e8c5b53ac126c46938c0384d"
    sha256 cellar: :any, arm64_sequoia: "2a5bfdc2c581f025649c87b4c398d8392d61f2c62e90674b0a4e5b9c2f752baa"
    sha256 cellar: :any, arm64_sonoma:  "e2c68aa9a9a78051b113c3258e9449dd9656596d80ee9c2a89c92f0a3b6de66e"
    sha256 cellar: :any, sonoma:        "73bc1b20daa359eb7f70f70bd256117d6d592a6909386887c15b0e10ecaa51f1"
    sha256 cellar: :any, arm64_linux:   "d9e85d5a80d53436fa2c6685cfa14106d15ddc5cd929188b6c5d2f6be6519437"
    sha256 cellar: :any, x86_64_linux:  "93d965debcebff10a6b71bbbaefb93c47e1e0e7bd6e8b934b7efe3fed4ac7a93"
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