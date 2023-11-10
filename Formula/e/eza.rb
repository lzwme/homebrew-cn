class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "09093e565913104acb7a8eba974f8067c95566b6fbedf31138c9923a8cfde42f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c1a42bd288bbab73174057ddb8924ad9cbd506975640722acbf7ac3233295ae"
    sha256 cellar: :any,                 arm64_ventura:  "ab3e027dd539d42a097219e1764aea98294ac13c9922eff852f8301be83ebc9c"
    sha256 cellar: :any,                 arm64_monterey: "3c78d02d94547de9d9788a048f85f30c229d4767a323ff2cc65b4be1939d97b2"
    sha256 cellar: :any,                 sonoma:         "0f707efd555b1543519e1fc1b9c9724a2f35859fe6fe4543ca88d4867b19f877"
    sha256 cellar: :any,                 ventura:        "c364a0d25f339921ebfe9bd9621acf9b453a1f6ca62e292d0e812694e636d395"
    sha256 cellar: :any,                 monterey:       "d46c90d3f049ca14ad30b9c983211c6d817a73265c966d06cb0b6e96073d3061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016a471440d13d8139f7bf9d9ab123db4bdddd6a5156b5187c1ef61ce447e385"
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