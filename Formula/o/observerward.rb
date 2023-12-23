class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https:0x727.github.ioObserverWard"
  url "https:github.com0x727ObserverWardarchiverefstagsv2023.12.22.tar.gz"
  sha256 "17a83b8c564af7d221543ffe1c06f250a08cb153a40f4283b1c0af672f31c6f6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c85cd5d0c10e8df4da694a03830907910a5407477e35f9b8a6e60360f189d4b"
    sha256 cellar: :any,                 arm64_ventura:  "bf57063c36d12642f39a7122c0ba4d4d82c38a3e99e48f3bbac256b59267bf5f"
    sha256 cellar: :any,                 arm64_monterey: "78539136b63a3c372ca3165a7b427e1a45523d589635d8d212bef993eb309d91"
    sha256 cellar: :any,                 sonoma:         "d71d91af6dd4f9e9a62d132c34b98f350b32c882387917517e20bd3b27c091f3"
    sha256 cellar: :any,                 ventura:        "d445aa847906c9c9928bad6a4971e7b76910cf53e95f7507a6c0bf05798d7c5d"
    sha256 cellar: :any,                 monterey:       "e2017c31b5c7074e5205f6d32e41f6474abcf60126170b78cd219a70fc4de923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b34fc162d30e44d13ba1b3bd718c4c80fe5e44ba61618dbddbb84bd043cacf"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
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