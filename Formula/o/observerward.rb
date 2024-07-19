class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.18.tar.gz"
  sha256 "4ca439ac4631dd29209591c689b4d19c8d0ddc40349cc49509b08b33b1991e4e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9dd4c6c0e0da0bb08969455d5596ec54065e71014c319b1abe5117bc1000791"
    sha256 cellar: :any,                 arm64_ventura:  "600167705ee9b9d451122813d76a6f580ecd26c009967456be5d059b6e3d6611"
    sha256 cellar: :any,                 arm64_monterey: "2c5f94c27c5f061b4d923aeeb45938d53a53a33f622f6915eb55e4db2ee11ec8"
    sha256 cellar: :any,                 sonoma:         "439049d6e06cbdfea475b9c79279c48ae08b4d2afeaeb03ed04b1f1445b50b6e"
    sha256 cellar: :any,                 ventura:        "d2d531f7e40c1de833ef4fde054b8f019cb786fb04bba2dd87197efbe84cf422"
    sha256 cellar: :any,                 monterey:       "769502ad969aad0e4957594a6ee8965057a8c141b886648da499be02a423ba3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6cc0afcd40dd89340f0791003a620999a0b59a4ebd4183828aacdf1dfed979"
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