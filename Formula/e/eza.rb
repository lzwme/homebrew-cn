class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.21.6.tar.gz"
  sha256 "8433260eff7be158cfdfafc7dffd620d878c1470b937a88f8a20117591990c67"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86e4dc1c265cde6b8a337d506792d44ae1ef100766a424d7cb615d79eb00362c"
    sha256 cellar: :any,                 arm64_sonoma:  "a1c5268397be7dbd6b50defbff8c51f68363713da191dd1ff6db6ef434e1b43c"
    sha256 cellar: :any,                 arm64_ventura: "139b7ee477cdd6cd893153c04906e92f585efba6a32a488d90ec72960403285e"
    sha256 cellar: :any,                 sonoma:        "a4360c43b0a02d1ec38b72f31d517887ba4be161b03cccffc04224d9183be265"
    sha256 cellar: :any,                 ventura:       "e3147077b539c2b11f3e9533379e31f1a40fa4828b21dbd51cc068223e26e108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c49937a0cc5081a0ad37da39f31e1e8cb06eb7824ad80cf5f31d451622eb78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c5b643d5cf3fb4cf7ed3be183a6002aa735ed6df4040d0ba3fed7df5281d591"
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