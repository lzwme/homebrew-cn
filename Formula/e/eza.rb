class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.21.5.tar.gz"
  sha256 "85aff87a87bc66130a43106ee64fdefa572d709f5e1ae33d7ef1de76329d2950"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd079aaaaac26c8d96b7f7e26f3b1279e15dc5571ae7b3cd8eae836dd8483af9"
    sha256 cellar: :any,                 arm64_sonoma:  "7f81564cea8a7fc329ea6c7b2d25ad412a9797727dca738801c222a9098a4285"
    sha256 cellar: :any,                 arm64_ventura: "d5575219f5b934c2c681424360490c7486210aa2112592eba4ff3becd149ed20"
    sha256 cellar: :any,                 sonoma:        "f3f3da7d27642cfd015ae3bb567aff2a17a39c0ce1870f4d78e387ce8ab5c1f3"
    sha256 cellar: :any,                 ventura:       "5fffc0f03c699dfdd22d7d8dccbe37117e5730f8ca36f2d24d833ca3646dd2b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e0f9bb159c86c002d6f55ef82fff32aedf8aa0e21fd134a8f5a164a675b49cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be5c944b76fcfcfc08f80f1dc6badce9b8864ccc2145ad0a82e25113e643ce6a"
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