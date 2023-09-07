class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "fdaaf450cfaaa41d6ea8ae12fbb8e41e955e255b1169022a7675ca29d7d621c0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "311f5e0b71948ba646711dca93f6bdbf06f44a1271f67582490039f82457c487"
    sha256 cellar: :any,                 arm64_monterey: "5b0eafcf88ec260f84606986dcd8e8d7ae1a8c58bc05098cbb4cb4872f0f42c2"
    sha256 cellar: :any,                 arm64_big_sur:  "a891a78b12fef218239c3d4a3814057359b3ba47c3aedb9f1a0ff86788cb4104"
    sha256 cellar: :any,                 ventura:        "bc631f12244ad3cc79f9018ec312a109af45b27144d931aecb7359dfcbcd9c55"
    sha256 cellar: :any,                 monterey:       "3b27552d47fbf679f1b7ccc95b82e0f27ecbd7a64e69092bb3c717b260e7b5a7"
    sha256 cellar: :any,                 big_sur:        "30d988f922e1b29012e141c0992f8414248165e6bbd83ce0dafdb0bc25026458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2845fc8e6570c70d907d0452f078cc8aac5d6cc98bc5f122553c65151c33cc6"
  end

  depends_on "just" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/eza"
    zsh_completion.install  "completions/zsh/_eza"
    fish_completion.install "completions/fish/eza.fish"

    system "just", "man"
    man1.install (buildpath/"target/man").glob("*.1")
    man5.install (buildpath/"target/man").glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    exa_output = proc { shell_output("#{bin}/eza #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", exa_output.call
    system "git", "add", testfile
    assert_equal "N-", exa_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", exa_output.call

    linkage_with_libgit2 = (bin/"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end