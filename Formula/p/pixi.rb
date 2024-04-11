class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.19.0.tar.gz"
  sha256 "04689c09bd987b50245c5e9bd87a5c0a715e418ebefc1b3457d94ca8a6cf324b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "f477f9988bfc2e2538fd6d0e0a49732e505abb9dcaf1f3e2877065109473ac8d"
    sha256 cellar: :any,                 arm64_ventura:  "ea9cc41a7522d7c35e9c3497e993e75bf9cf24f3917128d8a3cfd41013c5e7e7"
    sha256 cellar: :any,                 arm64_monterey: "7feb4db4c9d9c91a55426be1639cf09c5cae967b8d82944d529236a669317545"
    sha256 cellar: :any,                 sonoma:         "45078df9cb3304b8a0210900a98be4e3a213beda8d315fc6403033ec99f3085e"
    sha256 cellar: :any,                 ventura:        "2418ba6035f2982502be44928859ea58cb77499c0a96ea54b7061d4b8fb6fb28"
    sha256 cellar: :any,                 monterey:       "624f892927b24eab5e140663209745ec89ddf073b0738f946d853331e151ccf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c617f3095475d9714a4a3a852b4199e6d1a4c08c104f6b1c46e2f720ec09b0a"
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