class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "3b774d1396f7aa5382d358133f2923a49639b1c615fea0942cbc63042c15830b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "152f8f4eff8fe2692b5e17de5dd0e0a1b6466d46751f540f43bdffcaa24846c0"
    sha256 cellar: :any,                 arm64_monterey: "c65f4b66b4c4b4893e11527b96577b15bbbaa28b59f313e3eb1c1b60e697f571"
    sha256 cellar: :any,                 arm64_big_sur:  "3e53f0369476b20573591b186cf9c59e614af9200b41d5a4233db1535f521d0d"
    sha256 cellar: :any,                 ventura:        "e03e871cd4020d2343437e928b0d3da64ed4231c93e4075e48cde84e49c9238d"
    sha256 cellar: :any,                 monterey:       "3bf49eb11d085c06100a26abb10a482a1406ea018083d90116c713856b0d3499"
    sha256 cellar: :any,                 big_sur:        "fca6c8aa6dab59d38bb781f2dfd8e25a740fbf57a87a938a15e2cea1b3f8c143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e550785e27ca1e262f711cd513ad03725e9ed7a5cf5c8ed31133ebbeecd047"
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