class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.18.22.tar.gz"
  sha256 "552fe9997ed4fc6e11dafebffc2aa249ab3fb465a05c614181c7b62e8a0df698"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8261099b8e774d01816971f0a19351b3f19c4a74d6e2e9fc0989ae441140d67"
    sha256 cellar: :any,                 arm64_ventura:  "f8ed1c69e0aa68f039c594f98cabc6f2a3c710874ba946a271a157187552dfaa"
    sha256 cellar: :any,                 arm64_monterey: "37a2cc89ed92497194ad1b7fcbd5967c6bcfda510a3e78fb8a8e01943d404cd3"
    sha256 cellar: :any,                 sonoma:         "5841814ca31d57985828bf90f20a1eebb2a3c2f55f9eedc22946942b6424780e"
    sha256 cellar: :any,                 ventura:        "8b696c34b27925e3c8d2d951965445a5bbc50bd2df61afdaaae67dd729c93103"
    sha256 cellar: :any,                 monterey:       "dae2826eea79cad1bd0850450ee01b77ee1bdb4b9017c6b4eee2fbad4ab5ae25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b28101804c418f7ab0460a97abb68f7f8e0e92c0949864e548206f3ce6f495d2"
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