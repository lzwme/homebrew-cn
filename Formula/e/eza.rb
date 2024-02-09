class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.1.tar.gz"
  sha256 "f4ac88d8304bf0e403f922f05cd2ad9f87fd6b034de07228e4248edd9c9d0220"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b8b083daecd0c954b62b88a45966e62ce8440604d02dcfd397ac2638516d729"
    sha256 cellar: :any,                 arm64_ventura:  "3ef9da47c07ed1c02e610e3af34eac1b04b0868f1b60df70cabe33e7c4e2cefe"
    sha256 cellar: :any,                 arm64_monterey: "0d7c2b1706822efb02923aa6fcc9deab65db5a5ee3e13d3aa32fa7bd63162eb0"
    sha256 cellar: :any,                 sonoma:         "a82a04c977fd5c528fa24a758293c5d4966184ceec6ca86b01ef239986c45047"
    sha256 cellar: :any,                 ventura:        "74ff2564028549162d6922c48baab152d9ab030045281b7d53fba1ac35644160"
    sha256 cellar: :any,                 monterey:       "e5a2dc238e138effe7639e1326a7b0b6c9a1d829b65e3b56c2fce9b61a58d6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33536b2abe24aa1637792c2fcb63e7e4b5c20bf72f3c32ae6d98275de67d941"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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