class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.15.tar.gz"
  sha256 "cbb50e61b35b06ccf487ee6cc88d3b624931093546194dd5a2bbd509ed1786d6"
  license "EUPL-1.2"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "505abe73711da7a64e6a16552872ca759ed535ed3e3a15be323a7a0ee54fbbc6"
    sha256 cellar: :any,                 arm64_sonoma:  "dcfce238d5aef157cdd6bcc332257edab22799ba3a90b8e7c9167459a8812096"
    sha256 cellar: :any,                 arm64_ventura: "c68517761a5dfe5892449c67c805fcbfee0db89b552c663debf101939306f223"
    sha256 cellar: :any,                 sonoma:        "0a1fcfacc59f8cba09914be880ec833a7e32f1578f3b6d6b0d01771c4a35acef"
    sha256 cellar: :any,                 ventura:       "fd814309742a4cea445b45e379d1cffacb78f243f9f5214a06fe071879c4b2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402b89fb0989927b9c7019c34ebab4120ac25f4d272af92cf02a32fa681fad97"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsbasheza"
    fish_completion.install "completionsfisheza.fish"
    zsh_completion.install  "completionszsh_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "maneza.1.md", "-o", "eza.1"
    system "pandoc", *args, "maneza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "maneza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}eza #{flags}").lines.grep(#{testfile}).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end