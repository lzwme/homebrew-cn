class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https:web.crev.devrust-reviews"
  url "https:github.comcrev-devcargo-crevarchiverefstagsv0.26.2.tar.gz"
  sha256 "b2204510acf65667418980dc6e93580167e738376ee888f810064542fa04ef92"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86f84ff2635fb1a77d18cb8a6fd2250a226c2d9a5e224a9fa0e033c00d53d7de"
    sha256 cellar: :any,                 arm64_sonoma:  "68b55d4831b5c770f9f2e9decc416efcdc1da734d4264280f4765d27ca400cf2"
    sha256 cellar: :any,                 arm64_ventura: "9199253f5e4adf8f0b4e7d9bb8c3705daef619882c5104b1e498b9ad9180e0dc"
    sha256 cellar: :any,                 sonoma:        "2ab213753e97b52a63a3b77d372e207ca5b5ed1db56ca31988561d026ad6d438"
    sha256 cellar: :any,                 ventura:       "e5b487c6b3e014551eaa1ccad4b0cfbad9e8015a105483c00c6aa0bdb90042cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a83a5e8d5797465d4c502f5fb2067e8b4a298a3c9fd91cfe7f58ecaf5ff00f3b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: ".cargo-crev")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end