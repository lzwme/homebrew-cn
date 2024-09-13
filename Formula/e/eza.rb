class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.19.3.tar.gz"
  sha256 "c85760bcc14259f87937357cd1c8c9d301fe3d4d2da2e6129b572899e97345b1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "52f4289dc12290a1e51a398923a78f23ff14bf5f0bfbdf9e14165bc54194d5c0"
    sha256 cellar: :any,                 arm64_sonoma:   "6fdf6b57ed385c3be64c21734f4372308a45104ea99eefc8c8983e8018ff7c80"
    sha256 cellar: :any,                 arm64_ventura:  "ba6b66fec4e5bf90177d3de4598d41c1b5f518916fbab19df68d940ee27ca78c"
    sha256 cellar: :any,                 arm64_monterey: "dad36a5eda9c5d09505a3d2cf1637de8a21ff54614b79a44e8ddb99dbac9673e"
    sha256 cellar: :any,                 sonoma:         "67cc3f91b842b4ede7f6db2902a286b55fff38005021bd1fb0f109190b1bead9"
    sha256 cellar: :any,                 ventura:        "c6c227f1391d7b87ff055b9b1ddfbe0035e41d83dbf7ae135eb6c4ebd0aeee5a"
    sha256 cellar: :any,                 monterey:       "715aa8f4b09d2a710c9d18b448316258606a54895d059531225f66372ddaa9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d450b6a5554503e9b355ebdba2999dd04b5151abc3c5911e0c9bb38006e8d0"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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