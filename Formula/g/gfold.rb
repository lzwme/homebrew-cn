class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https:github.comnickgeracegfold"
  url "https:github.comnickgeracegfoldarchiverefstags4.6.0.tar.gz"
  sha256 "f965daa340349b04bd9d29b5013dcb3006d2f5333cdbae1f1e3901a685e7bf7d"
  license "Apache-2.0"
  revision 1
  head "https:github.comnickgeracegfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3f39968905493da2887c42a234a341da936cc46ead483ca56888396dd325227"
    sha256 cellar: :any,                 arm64_sonoma:  "691802c014e5ba101e3c70e9e7f198c32d7dd3e0cec2ec5c6e315225327519d2"
    sha256 cellar: :any,                 arm64_ventura: "617d2c377199fa4b6ff83106a04f3ed75fdf219239f5497966f2ba6fc9a2ef85"
    sha256 cellar: :any,                 sonoma:        "25b560b6af51200d61642b76d391a7033905f8af3b535794db2aa5a86b7eb8da"
    sha256 cellar: :any,                 ventura:       "d468c1cafee8579904e3e92445806fdeeb33515bb9e436c957eaa2c0cb89254b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0332deac0f1b1ebe9a68d14ac953edbc09c94b2c02e3c7d47eef2616eeb7c020"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

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

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}gfold --version")
  end
end