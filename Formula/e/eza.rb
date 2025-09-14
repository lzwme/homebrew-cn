class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://ghfast.top/https://github.com/eza-community/eza/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "88a77b47c182ee22b3e13353d92d4b78e15072e05f377c8b8629f5697df15d87"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20d98f2b70e9fbf3b6c50ccf6aebf35dc6dd58f8cab9bd3a52349e4f36aece54"
    sha256 cellar: :any,                 arm64_sequoia: "64c6b94fbc9ee2b76692dc5e6d73b1b399dd7d7f969949fadc4ee32936cb48a7"
    sha256 cellar: :any,                 arm64_sonoma:  "81c24fc59ccc9fb1ec6f9261980f17e8cbf55a12a96e53f121486fa36983c4df"
    sha256 cellar: :any,                 arm64_ventura: "b1426ae21834f3ec415e0f17236f26daf878ec8613862799fc4ffb696a946ca9"
    sha256 cellar: :any,                 sonoma:        "0c5c3333e328843efc2f84ee3d976915cab6139b1f5323dda99d112d0634dce2"
    sha256 cellar: :any,                 ventura:       "ceddcaf9f8c3af14334eafaa94d250355551683bf35b4b04d7028219d7b3470b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac51d91805875735c95d60055da008f5ef9d29f2db84a30e3d4f4b4b4b6036f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2247faf35b56dd046352b4f6f9132b96a574dbb2341bef44cd3e925e0561bc5"
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