class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "e1c9e313ffb98730e8bbc90a30ea951237f38474108072e9253ae89951ba8cdc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fff1b111d4180d69107e79a92685ecf2eaa072396d17b2eb1d5a934af58d7400"
    sha256 cellar: :any,                 arm64_ventura:  "6d7c4b0fcf750ce4ef30b54874e9736c05ba07a1e946df71396b900c88bfe357"
    sha256 cellar: :any,                 arm64_monterey: "e192b858a6714ba639f1905583b02ad53f98f15362afb71843c9b2857502361e"
    sha256 cellar: :any,                 sonoma:         "faa4ea61b022b5c28ebd8f54cd3dd194e06cce50b90be48d67179a751c31087e"
    sha256 cellar: :any,                 ventura:        "edf4ea801275b481a83d09a5b624ae24c933228b03dcce7948c67d324ce9d8ac"
    sha256 cellar: :any,                 monterey:       "4f5ce2694b83cf62af866361f7fcec1ebd9078e40dff5ba8139ec2bea5c02e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d003bef67a4541670b164f1858185abd3a66be20df2730aae71baba127b36da0"
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