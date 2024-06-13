class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.24.1.tar.gz"
  sha256 "07c1038f1ad20b45873f7c00dd806f0b1f032113a6492e908ed85932ec78a979"
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
    sha256 cellar: :any,                 arm64_sonoma:   "662637d306a502f7d72b8bd74587639c8952e3222158509514b23052f9c4cc0f"
    sha256 cellar: :any,                 arm64_ventura:  "a44a47961ebdcef39fe829ef3afdbc1ba5e56ead3f1ac26a0b7ac5db734e5582"
    sha256 cellar: :any,                 arm64_monterey: "b830a719474c078d9b021fef429152033a2fd3a888dee9cfa4ea239281246470"
    sha256 cellar: :any,                 sonoma:         "a42b5a19fb300713efc1792e8701489bd06ddc5ae60eb3c6c6b297a589da0dfa"
    sha256 cellar: :any,                 ventura:        "abae45da7aebe11a34446b9fbbac65da3e465681626b2043b1d360e082778adf"
    sha256 cellar: :any,                 monterey:       "3e0ffadf6ca254b0552d812036701d9bc934816f4287ea70349ddcf9e7947af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05eafe969319f7b6a56110575a0dfd5bc506b3f6fada4d183d8ec73c9f96aa2c"
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