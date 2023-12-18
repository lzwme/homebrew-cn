class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https:0x727.github.ioObserverWard"
  url "https:github.com0x727ObserverWardarchiverefstagsv2023.11.29.tar.gz"
  sha256 "dd17eee7f845140184ed583c46182b76ddb8e2030144c33714cee4987ef6a1de"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb998657e7d5c082152c9d3b717c936035d058a79569e3c59319e736b5b08cb8"
    sha256 cellar: :any,                 arm64_ventura:  "2fac90fee4e357b44cc847efe48b0d0040d21b6b60df8f75ed39b2695942a4d4"
    sha256 cellar: :any,                 arm64_monterey: "f8c1081c4edeac00d8936565ce7ff10533113a5f4094599240317ce8dbbc137d"
    sha256 cellar: :any,                 sonoma:         "45a08a2173298661e42d8b7a0eab9721990851f2043f2f9bdacd1a0250b5d797"
    sha256 cellar: :any,                 ventura:        "69e9dac39df27c449c3bd958b6b144dbe51a2d4b20582f453c42ed97635ba375"
    sha256 cellar: :any,                 monterey:       "2df3bbc11470bce7ce338afe5d14b05ef2591fe6d9046e2a605c162e898a3e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb72ef3b28e4b564d40805b92001d5476b360ec794f2fa9d0508ee75a1c62a71"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")

    [
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end