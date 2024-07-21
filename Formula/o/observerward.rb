class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.20.tar.gz"
  sha256 "0f48825fff557d1e21ada31874ea531e34c88090c809f816116fdde3840fa3fb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca79c6a21602d7a45f49276c30e45767a0e490d65169f27404c9c27d87582556"
    sha256 cellar: :any,                 arm64_ventura:  "80e74530c28747ab6aff8b0c82ca737fce9154a0e3745aa36dedd987c7c3c42e"
    sha256 cellar: :any,                 arm64_monterey: "6c7814b703d8be8da632eec6e9505689d996215806c42b4390150d3f8ea7ac20"
    sha256 cellar: :any,                 sonoma:         "7347ed9ffc1242f82eb7f035a0ca94e8bf942ecc95255759b23cb0cd26d0dd4e"
    sha256 cellar: :any,                 ventura:        "db8db0ea04a997a6f3cc8d2f8ca600f29a0eb42df2c912c22ab3edf1f30d1e9b"
    sha256 cellar: :any,                 monterey:       "ec3dd279516ae8829e69065c9d0b392404b5376d1ecb45536eac197b83e426ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d0aca4d18f579cc16694a83ec7e6f908120bfc563128e592bcbfa0b3c865ab3"
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