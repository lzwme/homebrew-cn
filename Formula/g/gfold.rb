class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://ghfast.top/https://github.com/nickgerace/gfold/archive/refs/tags/2025.8.0.tar.gz"
  sha256 "2501dd99082315b1ef465c2da1678c8dc2ba39cd8da9759333c0c05424f23b89"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b27ff4e5065eb259b7fcee9d71c76e3ffce41e318e847fd97472752d7b41522f"
    sha256 cellar: :any,                 arm64_sonoma:  "b73b5e9f92dafe0046aa3852c37f67dd7fd86a41317ea54e3cc2d55c8dc4e39e"
    sha256 cellar: :any,                 arm64_ventura: "99a678ef3863b174c743a2fe1176bbec2d4a36b6c6ec04e084ac22299223060a"
    sha256 cellar: :any,                 sonoma:        "72880a0d5a9906b3c6ad4fe30f6087a83a753d6e65ce5fee6bb4311232877894"
    sha256 cellar: :any,                 ventura:       "1b8c76167ce9c55b5dda0b2a3e268d624f9eef470201c76ba57dfeaea46ebda9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c2770267e582ba0d9f1f9b2cc33329281bb2a8861eb0b25a30663ff3c1e50b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b98c891ce9c094e64674052d14bb9519da394b027d3cc08c018724121ec4002"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    rm ".cargo/config.toml" # avoid using mold linker on Linux

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

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}/gfold #{testpath} 2>&1")

    # libgit2 linkage test to avoid using vendored one
    # https://github.com/Homebrew/homebrew-core/pull/125393#issuecomment-1465250076
    linkage_with_libgit2 = (bin/"gfold").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end