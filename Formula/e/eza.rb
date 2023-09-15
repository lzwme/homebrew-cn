class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "766e754c9f4632b92e4a773ac496dee8b6b83fdc9b8ed9514750058039fc5a83"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63cbf6174e8240d67780356e23e96258b77225aa27fd90089eec8f3637634227"
    sha256 cellar: :any,                 arm64_monterey: "1156cc85b321e77f020bd3bbaf20b4ad1f3506f5d18cd4b628ff518b30e1991d"
    sha256 cellar: :any,                 arm64_big_sur:  "eb61b3290a4fd982c5c71cf01794e437f107784e7b4834f728aca0f6906f978e"
    sha256 cellar: :any,                 ventura:        "fddd2c433faa6d8e0777ac6cde2e83b7a909950a324b70b28d6878b1484e574e"
    sha256 cellar: :any,                 monterey:       "54121c8dc952f3aaddc594939d15914a552c1bc928d9cc0ebd5edd8b337c1932"
    sha256 cellar: :any,                 big_sur:        "b6f8b600aec8a29f3f53b96e410a720005dca3566fbea9637ccfa3c6d2f0c318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35410a8a567980a8f3795e16022a2af08a6b555938a2c18aa84152839762f861"
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