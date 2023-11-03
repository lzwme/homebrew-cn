class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "b8b00af94d9b8f254b5a14af3da84542893617f810dcdad782e5667a1e7af1f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bddab9bc73f49c8734250c194236c68a88e1837f03fefc6f29e079d9f29e2fe0"
    sha256 cellar: :any,                 arm64_ventura:  "098d9485a997528e0ad08c3e08f0d46f53bd9dfe7bc5b5563ad0f128d0ab7d81"
    sha256 cellar: :any,                 arm64_monterey: "b6a64eab92217de48293d21b42e07f083d526d32cf3f64fe9545f05356a97a77"
    sha256 cellar: :any,                 sonoma:         "efdaaa7bbd7bb77b4c0641e0052ebdf1418b3bf1fc8e6b9fe343dcc144eee01e"
    sha256 cellar: :any,                 ventura:        "57620852023dced89d7f45988182bad3212d69d4c7c4746eae298ce133b2533d"
    sha256 cellar: :any,                 monterey:       "5388bb5b54b3a595e0948f6459559571cbdfb00aa3c30e9da31e75885cf878fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027c6f294fd6f3ef3a4f23a09eb79edeb2d11e1a9f79a1741fb14484c414d099"
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