class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.23.0.tar.gz"
  sha256 "57e4c9746e3d392623a02ac918c02e90f1af7e6356add4d22d5bde196712adc3"
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
    sha256 cellar: :any,                 arm64_sonoma:   "5bf9cca0f855dd4808d7ac008e5453573314a5524b5a034d37ec5c7956bd5ed7"
    sha256 cellar: :any,                 arm64_ventura:  "932fe37e1cea2f471488720bb487a8d1fc80ba78d6432c6222b98af8e57fe987"
    sha256 cellar: :any,                 arm64_monterey: "f5bec871019de8c1efa62fb5f72b8186f5f7dd54655da77536c9305c40287150"
    sha256 cellar: :any,                 sonoma:         "026ffb1f1aed8dfdaed1b3fef9dcefdaea9188f21dfe02b595c22c23bc63b25d"
    sha256 cellar: :any,                 ventura:        "ed30689548756e82821c1dcad0f0521773a4c0c6f7c6ffa7f20e5bb5e9221cc8"
    sha256 cellar: :any,                 monterey:       "340a6c438badf2c1a8deecca31b47968d83423a1b9be1122d2514840371aff5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3110e5a2937c62c778dbadc787b97fd1b419a4ae280c5a19f3fbbdd386035fa"
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