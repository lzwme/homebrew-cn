class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.25.0.tar.gz"
  sha256 "1d7ae4ee972dee923ac5b9156f9116dc0bd0af5a190589279d59739372e8855b"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d9488cceb10ed49815aee5c0dfee3fe143173a3056e324782ad6f26c9c7ab549"
    sha256 cellar: :any,                 arm64_ventura:  "65a872fe600101290de211e71948357fa09570670a06c78df4be88971c41e769"
    sha256 cellar: :any,                 arm64_monterey: "50e8753c1c25436f0bd2eb61f12803797bc3f9665db83a2c58560b9c77c57411"
    sha256 cellar: :any,                 sonoma:         "ebffdf01bd26361f5450503fda19e0c9569490248d46b211b9ae04863dfa73ca"
    sha256 cellar: :any,                 ventura:        "c4127d236362022ddf504aea74e654989292a24ca77fb150222778f3998018b1"
    sha256 cellar: :any,                 monterey:       "51bb30f9c95da8c499b5a4ed6d68a2d789aaa955656bb13b1c429dac52c9161a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2a71583e3c88d133c3922b66a7b171124c11ce33e77a6b00acfd52933ff9162"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
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
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"pixi", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end