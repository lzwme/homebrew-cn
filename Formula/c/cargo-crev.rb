class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https:web.crev.devrust-reviews"
  url "https:github.comcrev-devcargo-crevarchiverefstagsv0.25.11.tar.gz"
  sha256 "b3f74da472a800805c79b32982c3d63d27149181d2c02d53304c67e3a0e84cb6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e5f44c3678e8fd73d051b338f3a63b922605c6e6e367d3750d7593f732fd5231"
    sha256 cellar: :any,                 arm64_sonoma:  "e63df8dcca92fad3e2983ce6190a7b5149e36fe7776a6a98c68ce6bbe633aa9c"
    sha256 cellar: :any,                 arm64_ventura: "cf868b3b70d163f2665a1608926b6f95da9b88a3815b9f1074398b5fcb535953"
    sha256 cellar: :any,                 sonoma:        "13ce45a9ff45ca0508509ea5f36ed41f7144ede7dd03f42cf074d7a1cd4339c4"
    sha256 cellar: :any,                 ventura:       "bcc8d1fe3bbc6e98c88fd8d208c2ef59f46fc88dbacf3d24dd61a2d1e507580f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a4896631809adb0ae4bd2f2f92667e27e8fc5cf535677bd5c7fb989fabb0666"
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