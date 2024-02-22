class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:github.comorhungit-cliff"
  url "https:github.comorhungit-cliffarchiverefstagsv2.0.3.tar.gz"
  sha256 "f9ef0bcc33d91f3e3e4b511f81cc0b850da126486756dd84c8672b35ca545243"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eba4b14f774b9f2269f303e86c450e028b2b51a76e6dc8fdc77680355af70bba"
    sha256 cellar: :any,                 arm64_ventura:  "72788a5b71e88b94d1fe92cb212c6d5dcdc18e7574e43128f76eee29c234c1fc"
    sha256 cellar: :any,                 arm64_monterey: "f25922243e0bfe9362d59fc3a556823dcf5c2a354bfd8120316b414589d58f05"
    sha256 cellar: :any,                 sonoma:         "6eec03a1e6942956746d39848c70e698651460a1d732ac69b082752579ba2850"
    sha256 cellar: :any,                 ventura:        "3ac44fa5e97673f25571621c033592d468176e45c0e8828784bff5e908c7896b"
    sha256 cellar: :any,                 monterey:       "26603dd870f5f0e05c5fddb7a37e115112ea869e78a4c0c6ecdf104d8ad34c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3e2b029e03c6416655a65cf03fd50a4cf19134e57771082e5845f194bbfc1e0"
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