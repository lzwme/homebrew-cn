class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "611692d82618f29cfea3834fcd16a5b5e96bd14eefe0939180a2479892a88d09"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e61b50cdcceae7821a781670a6b70e0c464b657dd6566fdab5a6d4cb46d122e"
    sha256 cellar: :any,                 arm64_ventura:  "f33f7114f8bca4771da17028ac1498b6008b8d5813b03a81f87ef9aa50e72230"
    sha256 cellar: :any,                 arm64_monterey: "f17a398242c682aafd5bbbac7c5ff2a903c01797e5b97a4f39b570d304211650"
    sha256 cellar: :any,                 sonoma:         "1f1e98af38824df19172f08593b814f4493440cc4464085cba81fb32c434a623"
    sha256 cellar: :any,                 ventura:        "4819102033802b9a83907938924b6856cc4ee319da8598694ff7faba22308b8a"
    sha256 cellar: :any,                 monterey:       "465eb17c578953747dd67b9e8cc3a0a32737a6b0e84ebac70add2195d829c7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf84526fd10fa4a5dc4bf2bf86f70a102f2c21eba21329fbd1f900d7d0f618a"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/eza"
    fish_completion.install "completions/fish/eza.fish"
    zsh_completion.install  "completions/zsh/_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/eza.1.md", "-o", "eza.1"
    system "pandoc", *args, "man/eza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "man/eza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin/"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end