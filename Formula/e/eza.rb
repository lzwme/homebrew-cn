class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "45553500bc18c28d93647ad38871d13a91485247bce3e8128b9773262ec22d10"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "37df138caeccc27828b817192b1570531873a6195e3f6ddc719a13abc53d4884"
    sha256 cellar: :any,                 arm64_ventura:  "319a414a3b1e8c93f2a95f1873d96ace2732f112b843435c9908e6156a46e378"
    sha256 cellar: :any,                 arm64_monterey: "1e66ef22ce425be0cafd73ee580a86095cf03378e3374c328764c49c68ab3935"
    sha256 cellar: :any,                 sonoma:         "b8add0b2739b83b01dcbbcbdf8f7846c17592415c592690c011124017cfe6c00"
    sha256 cellar: :any,                 ventura:        "270487d0272319b68c3712bfbf6beae35012b7b2881b06bf86d6f587e0f32e83"
    sha256 cellar: :any,                 monterey:       "980e48241e191713206b71e6ba1046ac15d92fde4f72373688d9a4f69737226e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0d2be0f44223e886a14cc49ae8693d8163619d674012b991caa7f2a2693495"
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