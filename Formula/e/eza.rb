class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "07981a535ed0eaddfe40c2d921fd996f53d1c8273ebf0a82faf8207d2ad1ee0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44ca20ad0d8e23b304622783f15da22956763837314cc27a6e77f3cf39a71aff"
    sha256 cellar: :any,                 arm64_ventura:  "64647d2bb723e939ab15d85354d350c40e56f3a2636c01e42cfc3dfd37116394"
    sha256 cellar: :any,                 arm64_monterey: "59c60d92245cad5486098f0a549f2ac26c6521e31498a6797e6c0df41e3ed134"
    sha256 cellar: :any,                 sonoma:         "45a58ce6f176852be4abfa3cb1289cf40fec61f2b077a48d20e27689a6ac059c"
    sha256 cellar: :any,                 ventura:        "9e9a96184e3957ad989e65f4d6b05c0dc13fbe0bc201a209ff8e0d375980b975"
    sha256 cellar: :any,                 monterey:       "4d65e458dba0d7e5ba36e11eef56844a6dc50ecd7509adb609a7b2b7e1c361fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ef7b397d34a50fedd87f4178e1d109e601900479c68cfef33edb52b79d2777"
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