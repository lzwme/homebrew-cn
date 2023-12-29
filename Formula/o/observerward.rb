class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https:0x727.github.ioObserverWard"
  url "https:github.com0x727ObserverWardarchiverefstagsv2023.12.28.tar.gz"
  sha256 "0f18ba047f6d560c82933aa4a2590a9768c784df4fd7f3203679407d9b4fb225"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8089c9048e0053586bfa4dc0e3135cb1e1a335eaff8ad5009f138a22dd9ccd46"
    sha256 cellar: :any,                 arm64_ventura:  "2a4f844f38a393d672ccc5af9be3966828fd23ad521d4ac5fb10aba8971c463a"
    sha256 cellar: :any,                 arm64_monterey: "642b708ebadeafd1839648a2ca699a87dbec48fc50996b5552c43d46bbdf5a52"
    sha256 cellar: :any,                 sonoma:         "a3b2e97effb238c9deab2d28a1994ccbc42bea008f2b96c282eefb2342825ca4"
    sha256 cellar: :any,                 ventura:        "e31b51c2aa3aba5eff1bc4f2fa97182faf085da1025ca7f123b4a5489131e8f5"
    sha256 cellar: :any,                 monterey:       "95ac38667003299d1c8f0d5516655d188d91fd58a75e1f343a776dff882cb349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa3784d4c2e92f6052d1312a03fb43b65a5bb2a44ff96e654a38366428e29c7"
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