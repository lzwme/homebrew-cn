class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:github.comorhungit-cliff"
  url "https:github.comorhungit-cliffarchiverefstagsv2.6.0.tar.gz"
  sha256 "0018be6e72a3133dbcd2e17ee4e12bbdc8d2762a38624d9590beced871314f9d"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4afdc3629b2f9645b9e4555d0ed73c2a3abdbfa4848c5c3ddc5db5167146045b"
    sha256 cellar: :any,                 arm64_sonoma:  "98df5ea956f2cea18f2091836a8009d8d096f4ee67596c2a9fd7b9e084f7432e"
    sha256 cellar: :any,                 arm64_ventura: "f8add7302dccecf2d781e79cfb11fce2c550aa405c80e74175bf9de09f4142aa"
    sha256 cellar: :any,                 sonoma:        "b4ba71bf2d674735ecf3361f0b4b981fbc4ce0e870ea37546def840352f309ca"
    sha256 cellar: :any,                 ventura:       "ce7277129c4899679972f7d2e75d0c8f61795f91a5b9fef661545787c7520e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f407ea310146ed09c929fbf858840cefa3f0ea5387b2667a3d52f27c88e0b0"
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