class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.7.19.tar.gz"
  sha256 "2b02cf8f8098c7b7d6de97ff5c9f0abdb469f570c0d2677e2c836a5968759d74"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44815e95b8aedfe061a0658d4a54e071183880deb06358933688a89cde66ca2a"
    sha256 cellar: :any,                 arm64_ventura:  "174249bba9b1e1e6737e70e294ae6f1312a7810e18737b657332b22dc50c9b4b"
    sha256 cellar: :any,                 arm64_monterey: "4f74174d50ef677af2d11c104a26e300e8ea2579c11e42514fa0ae046916ddb6"
    sha256 cellar: :any,                 sonoma:         "67cadcb5991f27a053678a9cfa9ad1f3c8fcaa721e5c9583fa06951afb5b393e"
    sha256 cellar: :any,                 ventura:        "8a57df3d04dc5354bca23719610132987f2f1c758cb1152bcb703fead7b41990"
    sha256 cellar: :any,                 monterey:       "b1e73863ba90890d406fb7faeeb573ae4190fa644bc75830c0b7147c4f861e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f3f8ba1d695530deb4ef5ccf63e9a4649c69b4d0a01288623a99baece673b69"
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