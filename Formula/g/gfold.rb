class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https:github.comnickgeracegfold"
  url "https:github.comnickgeracegfoldarchiverefstags4.5.1.tar.gz"
  sha256 "9569b236b09864aab0dcf2e5c16076fe3f0f69adc7aaf7668a37ea4d7365e2ed"
  license "Apache-2.0"
  head "https:github.comnickgeracegfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8e9be382f8056002de40f586bbd687493657f13435bd586ff368817cc0bd45f"
    sha256 cellar: :any,                 arm64_sonoma:  "106d8d09d1ff6e65daa8e8e9ce62748368fe8ff8e19370310465b597756d4b75"
    sha256 cellar: :any,                 arm64_ventura: "0d3bfaec00f91e40984be0f2413d7f05f3bc6c8c2b6079c1a6c2c1d5f94b71fa"
    sha256 cellar: :any,                 sonoma:        "f48163795d023e5d357d561b4838dec8a521fbfc46e238e71e801eddf0493070"
    sha256 cellar: :any,                 ventura:       "70b558991b67ba007d9725e983e8bd2d33aab16fe98b0634f33a77874bbaf35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913f7e7d8eef6dee5d58139f64cb12e87ed47775aefe3f51954c85c27e92fa1f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "bingfold")
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

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}gfold --version")
  end
end