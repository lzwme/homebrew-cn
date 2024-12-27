class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.14.tar.gz"
  sha256 "37e8bec3b2f7745f61d83d73ff0cb9a327180dd54f187c18c2d58aeb08d4da99"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a62b00cf5205b3c7758ed842314a8b13809bfa09f96e2ab24bc8afb60010e8c"
    sha256 cellar: :any,                 arm64_sonoma:  "83de43050f25601d88f7c1caba1eedf36e417b37352665893ce636ff5a956149"
    sha256 cellar: :any,                 arm64_ventura: "01888556951340d82ca944df2c82c292e3557da7237734be43c7b9005d89af8c"
    sha256 cellar: :any,                 sonoma:        "e57b70488f14aca38c6ceafb95d1f29b2a00726d462a1e928a68f733f9cbe532"
    sha256 cellar: :any,                 ventura:       "8d71d390209f70720355e693d690e0c5945d27d6a280acfc53c472f8757e8c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e606b0011118105cf4ab2681ad3eb7469da7e5a3417b0a480593963d2cf87a1"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
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