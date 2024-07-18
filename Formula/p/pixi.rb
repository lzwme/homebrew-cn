class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.25.0.tar.gz"
  sha256 "1d7ae4ee972dee923ac5b9156f9116dc0bd0af5a190589279d59739372e8855b"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "685880645ba83c321e6a440fe040e3c6f06eb9667929a8d0ec1f01a23d443c07"
    sha256 cellar: :any,                 arm64_ventura:  "bed05569122885b4867126827feecc44e9f822f36e12847e961f334f57e22756"
    sha256 cellar: :any,                 arm64_monterey: "c791e55ce59322d9dcc79c45d9a03573232c2a3709ca95cc15009b45ed55bf6e"
    sha256 cellar: :any,                 sonoma:         "29bef1bf40b01ca56124978630ec1f5849ac8ce86a3ca4afc9b4798c95eda9d2"
    sha256 cellar: :any,                 ventura:        "121555b3a6b143f89c84b86c6e208d14b614258ab54fea5bafbcaafc9527a33f"
    sha256 cellar: :any,                 monterey:       "b245c368f52c80f5d5000d57bbc82404a2e5e0c27628feeebaa32df6169e25ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd31ee3c22e4464c0da0ad59d73f35260e22917666cabb574db71f6994edc169"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2@1.7"
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"

    linked_libraries = [
      Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"pixi", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end