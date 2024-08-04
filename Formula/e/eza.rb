class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.24.tar.gz"
  sha256 "bdcf83f73f6d5088f6dc17c119d0d288fed4acd122466404772be5ef278887de"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7806eabdf2ad188a83815e4bea0171e3f49220950be450d80f6673d97407d73"
    sha256 cellar: :any,                 arm64_ventura:  "55cb981525451cd1e11fdabaf74252fd0830d23ca35b79d4d12cf66b06fc1485"
    sha256 cellar: :any,                 arm64_monterey: "c960c26cc6289edfdb6ac4703ef5d8dec5e29a269d1288f1ade021281709881a"
    sha256 cellar: :any,                 sonoma:         "3d85e36cf3d1dca06d22f3b32ee507e3c902f74dc38831d9c33a71935709ad1c"
    sha256 cellar: :any,                 ventura:        "8938e28d4f5a35cea1d954ecf52167892fdccdcf61e1adcf84ad13d111f8e75c"
    sha256 cellar: :any,                 monterey:       "a306f8d2065572bebc709448269bcebd26a9bbdf6da0d4ffd733d38abbf16f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "372f1cd842ac02835c9934540c138414232df844cd87b92db46a746d71a8dbab"
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