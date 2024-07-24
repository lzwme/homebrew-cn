class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.23.tar.gz"
  sha256 "538e5b77ea8c57464572662c02033efb718d565adab0da7d7d538c7f524922bf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46d06c6363b28441b95b78a5cd02f6189e4a9dfa3e70a2c7d1fe7e14bfa55150"
    sha256 cellar: :any,                 arm64_ventura:  "3f786952b409d8a3fee19a059cd429b2581a108a64940a44d71f304d5138b381"
    sha256 cellar: :any,                 arm64_monterey: "737022372c19064ed2b36f6652194307da4e4b87c9e62feaa4277ea5d90f524f"
    sha256 cellar: :any,                 sonoma:         "5f454b33f1c1c2e5cf2ebb2698fc44e758fec64e7476ff72aa03e682a35bed7b"
    sha256 cellar: :any,                 ventura:        "90f0e772da7b78f8ca28f26eb482fdb8978fbfdef0051a18ee564d21f6b17af3"
    sha256 cellar: :any,                 monterey:       "54c3a4103653e349a91c583d03d14d0c39d85d6fbd5b4cb411beeed92c785026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc0b220041c9155f8a552ced00dc8653e38eab77ed7382b02577f25fabfd668"
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