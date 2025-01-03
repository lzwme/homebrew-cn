class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:github.comorhungit-cliff"
  url "https:github.comorhungit-cliffarchiverefstagsv2.7.0.tar.gz"
  sha256 "7b9a74f0871983bf5c326ffd7358ba46925f14a6feb1638c8c1e5d6b36448eae"
  license all_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aedb37147d3717146ef417f2250aa77e73ec5f728b33376e37fe5d1dd05cbfff"
    sha256 cellar: :any,                 arm64_sonoma:  "13f0ec24c3b22b8eb69ff5b383c6efb31a44a2e63f5024bc1b4aa564501d9d1e"
    sha256 cellar: :any,                 arm64_ventura: "a25395c75240a577fc7a6c07a38230b151dded1ad86f298ce9bda9391e9c4678"
    sha256 cellar: :any,                 sonoma:        "86fcc21689a42c144baa68d22288e76d1e84b7161586b5271b1c407758e9e4eb"
    sha256 cellar: :any,                 ventura:       "33909965790ebad4b95b7439df2902232c0541aba3d4ab930d09f57b00952004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65783fb1e6349664f752ab2d87c3dcd9efae6193ce25f353e9ffd09dfb3f1641"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

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
    assert_path_exists testpath"cliff.toml"

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

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end