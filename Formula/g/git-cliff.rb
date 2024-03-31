class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:github.comorhungit-cliff"
  url "https:github.comorhungit-cliffarchiverefstagsv2.2.0.tar.gz"
  sha256 "d89af1c654e63ce2f6c09cd63d691bf531f0ccd76b670316cc71529f1d4eaccb"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2dcc75711cdc28bb0c9326109208142ecc5c39612c6580e2c1792f977e73f3b9"
    sha256 cellar: :any,                 arm64_ventura:  "91e9975b14039f9778d344285bfadd474173bddb2a01e303dcf68a2d4d622107"
    sha256 cellar: :any,                 arm64_monterey: "2725c6993ded1de61f96a366563f840c7c055c97ccf381cbe69229694d09cf32"
    sha256 cellar: :any,                 sonoma:         "94c7aa93cc822887f91e77a87a04ae386f259f501b6b8abdf0ca9c1ae576e89e"
    sha256 cellar: :any,                 ventura:        "649012478797523b4e8a1ae23e9580b1ef7dc6c59913f6d2fe67be0e2bea431a"
    sha256 cellar: :any,                 monterey:       "4efbae04ba2c0dd7b52cf0d319c02d5888753fe9106bae21b174b81c6365f010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec3b680def6375a1204d826522c7668c24fa57269788626efa768049929cabcd"
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