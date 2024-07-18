class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.21.tar.gz"
  sha256 "53cee12706be2b5bedcf40b97e077a18b254f0f53f1aee52d1d74136466045bc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0854de570e63cbfdf9fae5621dc8e2ccbfaea9c6da285af20a079176971848e8"
    sha256 cellar: :any,                 arm64_ventura:  "013a2a3775c9662ae564bf25803b4af969794eecc4e11982739c117e0e331a1f"
    sha256 cellar: :any,                 arm64_monterey: "ac680d3b53936978b868703bea2fbaf7ba945dccdd15988e6d72748d963d53cd"
    sha256 cellar: :any,                 sonoma:         "27155a9e6877e06c7d4f20ed624113284c6e1590a6634e83a9e56e318581c2bd"
    sha256 cellar: :any,                 ventura:        "56d42278429e45035cbeeb8b8188dd9676d8bb1821264977c8fef19fb165b137"
    sha256 cellar: :any,                 monterey:       "5d8ba534926d64696476d6c443ff007dd098a306e0b63af11042cd2bbff52431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6ffcf5720ab64cc6674c62e8c4595c7c60b89010188fd46d923fa62c416164"
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