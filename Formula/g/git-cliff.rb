class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:git-cliff.org"
  url "https:github.comorhungit-cliffarchiverefstagsv2.9.0.tar.gz"
  sha256 "449006d575e547fac9aae06d7246e51dd2d91f77dbfc42f7c99e32d742e46876"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd0b50cb21da044e43fa564a599034e01013581b910e88c289d08698b0356ced"
    sha256 cellar: :any,                 arm64_sonoma:  "67aca56aab16bdca16675644bc04f6009f51cc98d0a5c7fe6e1bfcc44ceec8cf"
    sha256 cellar: :any,                 arm64_ventura: "318dee462f9b80d1cbab459bf7bb7fff05faf4689bd12ce440882e38889e87ec"
    sha256 cellar: :any,                 sonoma:        "a36ffd46247a9fb8179ea995c9b3e681bff6da648b9320a82f987bc03467ab2b"
    sha256 cellar: :any,                 ventura:       "ca0ce40f456e217ed0f24b4ea922efd3592f72c73264b2144ef82ddb10ad88e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b941c75380f84ab46c03a696fe07c26e20c2f0fb1e7c3bb633a0c446d8b136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f982136f91a8029916ef8517ea3d9e208a6c7df452d6020e9d4bac5d046be8f7"
  end

  depends_on "pkgconf" => :build
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

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end