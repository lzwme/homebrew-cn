class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "dbc2ee7c8c20383ab2ad5daeadd0ed4624ba41fea1791a6698ce1309bba1e27a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2536ce41e8ec626f2e5cc99cc354aca67c753b0c490eff5ceb19b3da180982d6"
    sha256 cellar: :any,                 arm64_monterey: "a1a197aac270b8f60ae7298f53b63d9bbede5fc4c7de1f94c9cb115a5190980e"
    sha256 cellar: :any,                 arm64_big_sur:  "9dcf06c5bd51c87ee8c269e7b349cab54eefcc5d201383a425954308de7c664a"
    sha256 cellar: :any,                 ventura:        "a559c8de30deb52f6e992c6b88dac112fe93b1cbe65c53849aaa869c1dbaf9ad"
    sha256 cellar: :any,                 monterey:       "d94cdb8c6abfbcf49fb79e724f6a368841c41c6b772a7db939d31d6f9c5c5d25"
    sha256 cellar: :any,                 big_sur:        "3fa35b1958c814a602603dec50439e471ab313e5a86347b5a3dd8c9e9d8b79fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a635d47ccfa3b78e80e72e7dab8389e9f7b4145964aa6bd19932e333fe3161a2"
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