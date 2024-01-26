class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.17.3.tar.gz"
  sha256 "8facf4f39fed32b3562b70b2771a8ef3309efd68fd04685446a6df631f133cc9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f083231ff2dc679c3f91e27a361a09321753a3f846964499f90ee6ba96841717"
    sha256 cellar: :any,                 arm64_ventura:  "717cb7a4962f084a6b41b50f57358272b03fe6bf9dc7df7e15730ee6677eb841"
    sha256 cellar: :any,                 arm64_monterey: "6df02ae5a6bd8fd3aee76059a3ed5de7aa858fb047f3037bdad4c793653dca6f"
    sha256 cellar: :any,                 sonoma:         "d8011b975208478cd665145fcefa485b43801bb9a3474634ea92cd24685f856a"
    sha256 cellar: :any,                 ventura:        "ae422aecbfe459faf39f25a4cdcab93f1211807d95ce148e8b17a94ef135b33f"
    sha256 cellar: :any,                 monterey:       "6d7058741305a38794aea0e3ebe5dc68e9a8f53805b4878d1f57d402793b0850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb1cc211259b8b81a30c1581d1ffb703c6fa93185ea3dd32a01d0e1d217ecb8"
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