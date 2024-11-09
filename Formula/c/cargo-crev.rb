class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https:web.crev.devrust-reviews"
  url "https:github.comcrev-devcargo-crevarchiverefstagsv0.26.0.tar.gz"
  sha256 "49a59c650945c000071e850346b2ddb86e4f0821060dce411fbb3d669fef31d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "278811134c27d88aaa656ff6ba7ebe15074e388e7fa9d4fc50f1803514d5419a"
    sha256 cellar: :any,                 arm64_sonoma:  "7aaaeb5d29dd662954b84999416eabb006e73de3c6c98631df7ba4ac7e42fdcb"
    sha256 cellar: :any,                 arm64_ventura: "6a552a852cc132a0c0d30f27672c9098a8470fadb6e4b765ecb1f481ef26ff88"
    sha256 cellar: :any,                 sonoma:        "b2b3c04265d11102e8115ced2ce6d699d153326fe76b4ec1a41f8cae3ec1efd0"
    sha256 cellar: :any,                 ventura:       "c974ba8bb5b92c0dc31c6b5dc29761101f4ca16d8f17eb5ed605100024705ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b22aeffa3ed897e2d9017d110006a84cde521ee30374452a5f127669d99dcb6"
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