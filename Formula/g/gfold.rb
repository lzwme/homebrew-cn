class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https:github.comnickgeracegfold"
  url "https:github.comnickgeracegfoldarchiverefstags4.6.0.tar.gz"
  sha256 "f965daa340349b04bd9d29b5013dcb3006d2f5333cdbae1f1e3901a685e7bf7d"
  license "Apache-2.0"
  head "https:github.comnickgeracegfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd2ca816556e8a893c01b2a320e35282bd77f5a386fc503f20c286f468ac518e"
    sha256 cellar: :any,                 arm64_sonoma:  "01944d8c7f8e847f899751ba69b3db2f4f93049c4f24d7c407541c81e5695315"
    sha256 cellar: :any,                 arm64_ventura: "21397ba345e6f2cd59bdf91ceb1772d322b236750b5947d5bf7a36384bc55c0b"
    sha256 cellar: :any,                 sonoma:        "d805c26de2ce0f7d960f75d80e5e987d022555134b8997bcb0e6483df70db6ba"
    sha256 cellar: :any,                 ventura:       "cf8faf3ddbab02fe26e3f2111ccb2ab07e8696433b50d4f9f8ae7f774e3b5f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "463d21fb88b6b47dccd50d90d4879206c528c6b6ccd17bebb6d05387d9a47d37"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "test" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      Pathname("README").write "Testing"
      system "git", "add", "README"
      system "git", "commit", "-m", "init"
    end

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}gfold #{testpath} 2>&1")

    # libgit2 linkage test to avoid using vendored one
    # https:github.comHomebrewhomebrew-corepull125393#issuecomment-1465250076
    linkage_with_libgit2 = (bin"gfold").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}gfold --version")
  end
end