class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.8.7.tar.gz"
  sha256 "f96aa673e6892dcfa62805d03bacfc1ccd6994bfc87d0ccc434a25b4526b0efd"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d83caf911a99d74dee66e2b957f887e554a53395c9b896a220e12cd43b99c8c"
    sha256 cellar: :any,                 arm64_ventura:  "cdb9620990b3f34df5a67ac73e66b3b7f48ea4c94d726e1b9f5358dc73361752"
    sha256 cellar: :any,                 arm64_monterey: "222a47139a4b1a820dac254e435f456687a73b88d3cec74d9dd11fa3927a4ed4"
    sha256 cellar: :any,                 sonoma:         "66b2917d25fa3bea1c6425f6b7702d3196c899fd97e08d84b015a6257cc3e1e4"
    sha256 cellar: :any,                 ventura:        "d0054a9b4a7b8a2f6a928b0f402f445205c51c91ccfd222a5a75a86a3b3e1568"
    sha256 cellar: :any,                 monterey:       "31a09cd39468161f02b07bda7857588b6f9d6ffaff7853ffd97f553e92013ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e8fc6ee1d0c0edab1d11a2c6d079dcc3f1dc8df853864b8b7ca6ecace44e93f"
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