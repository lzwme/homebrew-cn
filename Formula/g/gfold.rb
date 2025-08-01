class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://ghfast.top/https://github.com/nickgerace/gfold/archive/refs/tags/2025.7.0.tar.gz"
  sha256 "07d20cd5b396c3a696e689086c7f9337c76c9aeeb57777dcd18a271a09039d27"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c0077060f3c96ac43fd58ec9bc34b98931bf672d483c6960404cae1d6fb54a7"
    sha256 cellar: :any,                 arm64_sonoma:  "1e435273ced18295b9df6bb1d440c37041a25cba7fa5db40a27f984eb075770f"
    sha256 cellar: :any,                 arm64_ventura: "d3d7ac10ff69b03d3495f9612537795eb25c916ca236b4cfbf8c3f899590d833"
    sha256 cellar: :any,                 sonoma:        "1673cd01ec833138f223fc0719691dda2366d49769f85cf6a91646d296aacf1e"
    sha256 cellar: :any,                 ventura:       "36aaa2cfafc39e038e0898e5a342b4d62be0364b120228c8138aa8a9ae2a7022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07b7e2559d1b93658005fed5698f2ade7769cbfddf817d74c6e15a015a634057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d493481b106603f6a3ce54a35ec438ffc7b7276df3b63103b3855d011766ab71"
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