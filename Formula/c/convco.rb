class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https:convco.github.io"
  url "https:github.comconvcoconvcoarchiverefstagsv0.6.0.tar.gz"
  sha256 "e6a7dbaddd39172927170d5d0b7aec12c7b72531d8961963e6059dd432555488"
  license "MIT"
  head "https:github.comconvcoconvco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d3935804ee673dac405a2666336683616f4e426e124b43a5ea7310e4995ed7b1"
    sha256 cellar: :any,                 arm64_sonoma:   "902794609fffacf8a4895bea16bc5f62fbe61d6e42e7e4b878ff6880be0e0764"
    sha256 cellar: :any,                 arm64_ventura:  "a1690a307a760ff0779ec5bce8fea4f0e78ca4a941e8d96d048e9cbefe00b656"
    sha256 cellar: :any,                 arm64_monterey: "0ddff4579aa41e1e7f56bf1fba06ffd19905622371cace49642c0fe54e8c6321"
    sha256 cellar: :any,                 sonoma:         "98287b7930a2f98d2764560def4d7326e72098cb6f893f1479b45faeefad54c9"
    sha256 cellar: :any,                 ventura:        "c09e5ad6ce54f02b3c0ad421a38b6be6166b4d8c8cc826ac7c73143ee53eef7b"
    sha256 cellar: :any,                 monterey:       "b2def2b2af3644f4838801838ebc718dceed43d815bbb992c05f28f0c489e84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecef0dce0dbf92b77bf0339985fa945020247ea7bfdee80c272aaa79f052fb51"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "targetcompletionsconvco.bash" => "convco"
    zsh_completion.install  "targetcompletions_convco" => "_convco"
    fish_completion.install "targetcompletionsconvco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n,
      shell_output("#{bin}convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end