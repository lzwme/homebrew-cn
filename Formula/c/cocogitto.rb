class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://ghproxy.com/https://github.com/cocogitto/cocogitto/archive/refs/tags/6.0.1.tar.gz"
  sha256 "2a0e332b7028ffcfeb113c734b4bf506c34362730e371b03a3e4a71142099330"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7ea6d3b6f764424fa6df493edee224abfe1a704d5338fda66f831fe95254c65"
    sha256 cellar: :any,                 arm64_ventura:  "32d8ac11f3f832fb24072216a59a1039244232cf89c06e86badcd50706c48393"
    sha256 cellar: :any,                 arm64_monterey: "9ddab414d42665c64449de855cb25d2fa49084216a1a8b8e69ca34f9d77ca3a4"
    sha256 cellar: :any,                 sonoma:         "9b02e29067a5d95f0f29f414e5fa67f8aba499ac696ad585f1c652666b93684f"
    sha256 cellar: :any,                 ventura:        "01938712cb551e03c5c107395e1b266b8f155663b61935092aed7c30b124e8bd"
    sha256 cellar: :any,                 monterey:       "56815c69f1d5e72979ae678364003fb2d892adeae822d8b7f0cc7473be427ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a219c69423801fa39e9f5c390c47f8f87b63b6e5f3d20ca3b4baa07f66545dde"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    linkage_with_libgit2 = (bin/"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end