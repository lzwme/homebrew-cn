class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.10.tar.gz"
  sha256 "dbeba82ed85c18776aac20a4f91429bd3ab7e1bd3734344cd247e8f646516a13"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0769ad434e3ac2a45ed382ddc7eeaa224227e4e70a85259b31c386274b7b77b"
    sha256 cellar: :any,                 arm64_sonoma:  "0f993a00834b2bf4fbd3673b1730d7c1e1638087656c5a3c33927d1559cf53f0"
    sha256 cellar: :any,                 arm64_ventura: "d04dee882601bb5411318a5fe63e90158b02535de319c9a5de8556cf870d2a4e"
    sha256 cellar: :any,                 sonoma:        "5d199bdad7c53291349d8f2b4a052a97b179626b1ae14613edbf55a5a33164ad"
    sha256 cellar: :any,                 ventura:       "c762c1c41a0d70ce0e7dd2cbcba4a206b49b4f0483bb53ff4cbd1c8352541009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee98be504226e6cd5e0a38774bae15257b2a04bd99c9fb4753d81226a48452a"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end