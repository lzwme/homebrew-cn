class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e4cce5a6f60e6b7405af911e3f168cf17a1e86c33c292a449c1c25c15052967a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "db1b7468d426348b224230c69747bfb76ff5bd71cfec23651a9a97007c65859f"
    sha256 cellar: :any,                 arm64_ventura:  "d908a22deb5a47ebbffbc130e2afee57c61589bf184347cec6ed4fabe03b6d22"
    sha256 cellar: :any,                 arm64_monterey: "02e8c7e1e87598e4087069ed8ad2a101510b3ddb5d1d71bd656bdfbabce90991"
    sha256 cellar: :any,                 sonoma:         "4057583600690e2ad112b72ba0dd67eda9df1f36d4839543abd63a4b617131e6"
    sha256 cellar: :any,                 ventura:        "f1dfe92922a2934a549c7e59c9cb9fa61229c312fe3c6acd3944edfdffa434f8"
    sha256 cellar: :any,                 monterey:       "f261093b93fd0ea08203c96b963b673a75731ba3c9050efe8bf44385e4845d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd63a728275c49f197477ced7c6269a69b999949407ad3e3ab0f6ce41d03b7a"
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