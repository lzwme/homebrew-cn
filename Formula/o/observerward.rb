class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https:0x727.github.ioObserverWard"
  url "https:github.com0x727ObserverWardarchiverefstagsv2024.1.8.tar.gz"
  sha256 "0b46f7b7365c9adc8ed472009132666bc03bec90f23841c86ee38672d678df1c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "739841dc6b6084ba23cb10f9b2478c53bc3350e6a2ed36f95b9a76eafd7dce74"
    sha256 cellar: :any,                 arm64_ventura:  "61f28c3df68dd4183cedfa3095cc022a341ed67a3a3ef3541d0043e2bd9a784f"
    sha256 cellar: :any,                 arm64_monterey: "bb9de2fcb117a0b7f1b0e5b8a4db5d002d0cd492eaf6749d79c3cbd28640aaab"
    sha256 cellar: :any,                 sonoma:         "1ba02ffbdfc3805412428703865ad6a1fdce179a0a62f563574b4d9283d09f6e"
    sha256 cellar: :any,                 ventura:        "af2f9fed20364a4d856a5b9a8be4cf7357b29e2ae5a7fcf4fedf52b0999654e0"
    sha256 cellar: :any,                 monterey:       "dcc66610622bd250576d2bf38fc31bf68d76d3d7f7ea92562d4ddd40d509ba26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cecd9f1ddf3795a007b1e89c1e9816fcd81fd614879687d5b6ad5213dbcd10b"
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