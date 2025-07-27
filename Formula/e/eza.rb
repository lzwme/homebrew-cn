class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghfast.top/https://github.com/eza-community/eza/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "119973d58aef7490f6c553f818cfde142998f5e93205f53f94981a9631b50310"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40da5e7185a1e4569cc7b437fdfa98620fd916ac428b1c731c091612487d48a8"
    sha256 cellar: :any,                 arm64_sonoma:  "ea4574483948c94cdb1a9448f2769ecc0675b73216b307528413284f37440902"
    sha256 cellar: :any,                 arm64_ventura: "2384f655b0557ad14ab2ef716b3f1d73cbd2458a6bce7dc6850965b898c40f64"
    sha256 cellar: :any,                 sonoma:        "e20d791b21015430d1a19fa26442886f4bbf42235e7f62ba7068c8fa05d73915"
    sha256 cellar: :any,                 ventura:       "9b4dd504c1cbc14ee97ee1fafdfaca62b1b7d652f1c564db1d08428be181407b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4adcfafaeb000dfcfa8d40eb95642b76ecfc2e4b2492a3ffd2f5372a4ca7362f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d46c5aacd16ff102024477fb380d858c2b136cf834383e976cbeb2dfb644e6"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

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
    # `eza` is broken when not passed a file or directory name.
    # https://github.com/eza-community/eza/issues/1568
    assert_match testfile, shell_output("#{bin}/eza #{testpath}")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags} #{testpath}").lines.grep(/#{testfile}/).first.split.first }
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