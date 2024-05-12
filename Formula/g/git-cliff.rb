class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:github.comorhungit-cliff"
  url "https:github.comorhungit-cliffarchiverefstagsv2.2.2.tar.gz"
  sha256 "c47b517907cfede556c50d790fddc07039c7ab477a2a059dde57090c97adfbac"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "975a62a81642bfa9eabf0471da2929d04089393f36940fc2a463453abe3e0b6d"
    sha256 cellar: :any,                 arm64_ventura:  "42e24764e50e3537d152afe71de79ea6808b4d7e33416f14d1db841714141720"
    sha256 cellar: :any,                 arm64_monterey: "e0193dabf16cd4544411d013d87cc60e35cb4e4f59e307e988703d1029f39601"
    sha256 cellar: :any,                 sonoma:         "acc901af56efc37df60d53946c78dcf66137769ff21ba63a617c52f5439b9949"
    sha256 cellar: :any,                 ventura:        "b1ebfce30fde0ec6ab6c35adbb9b794f4e7cd22dfb83a4a77d1b43b924e60abb"
    sha256 cellar: :any,                 monterey:       "d497a18177eb396bea1cac582ed76c0bbcc33ca3c9b10ae26955ff82df63d874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "956b48f2f98f229b4a55382eafe9ad5a5d8c912a3a36024632773994a64a5a9a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    # Generate completions
    system bin"git-cliff-completions"
    bash_completion.install "git-cliff.bash" => "git-cliff"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"

    # generate manpage
    system bin"git-cliff-mangen"
    man1.install "git-cliff.1"

    # no need to ship `git-cliff-completions` and `git-cliff-mangen` binaries
    rm [bin"git-cliff-completions", bin"git-cliff-mangen"]
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"

    assert_match <<~EOS, shell_output("git cliff")
      All notable changes to this project will be documented in this file.

      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    EOS

    linkage_with_libgit2 = (bin"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end