class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.22.0.tar.gz"
  sha256 "7ac93a6bc89c81fb4bde669937b8518f96cd0585cfe07583f29f23d3b2bfdbda"
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
    sha256 cellar: :any,                 arm64_sonoma:   "21704db94e361a1fb4e0f9c0846cf877d6f5b12a402317045a2dd89344c9704b"
    sha256 cellar: :any,                 arm64_ventura:  "a1f9545c920babfbcae17f37472636eff8e432498d0c9c5c0a228146d5935fb4"
    sha256 cellar: :any,                 arm64_monterey: "3c3d57813c1850ca06210cd7b2b2964f536a17c0e80e76ce7255998330b174f4"
    sha256 cellar: :any,                 sonoma:         "cf18316c9366ea662b4953703f81f25bdbb0fc37af6e6b2b1963720d04a32490"
    sha256 cellar: :any,                 ventura:        "cf58c4e5077d5a597296fb73d79bdb697ceffc9f9cad0877e442bd554957022f"
    sha256 cellar: :any,                 monterey:       "038ad5d6b1efd498c387f4e9c439e7057372fda27603b8a525abbc853b745c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e838fa4c9cc66fc2e31cd407726e65cab150d47d2e2a7c8886f0049b2d5a0464"
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