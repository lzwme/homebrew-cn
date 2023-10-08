class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "00932e1c81e761490e45d16902356d8e6ae7efe4accc0a41e18c342424167f47"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ffcbc648a75eb17ca282e23e4e668d5eb7024f122d9481dcfe0fe58959fe62b"
    sha256 cellar: :any,                 arm64_ventura:  "e43231e93cb3621855808cbbf6b0a0c0dc64b605f5ed55555ba0e3f3279b6358"
    sha256 cellar: :any,                 arm64_monterey: "6cd4c2dae3e41629c4b2c698821d946c46cb045c4a868d3fa571df549a84fcaa"
    sha256 cellar: :any,                 sonoma:         "681848a5230e831898b8504bc9fdc95c3c6fb2d72e8f76b862af0e21c88935fb"
    sha256 cellar: :any,                 ventura:        "1f7e1792d0ac5fcb96ff700249dc7279076f6865f951d5c75fa319c1183f2cbb"
    sha256 cellar: :any,                 monterey:       "1ce0c92dc58f6f44762f0edae209bd8d76182360bf1882a8c9af8b0f6588cba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3a50fa886774a4e6104c0ab4821a28e79b3a2f47e52dd3400eb09ea359cf284"
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