class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https:0x727.github.ioObserverWard"
  url "https:github.com0x727ObserverWardarchiverefstagsv2024.1.6.tar.gz"
  sha256 "9deb126403f58ffe05f9e0e08cab9db636837694d94870315b85e9f476dd542c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8fd6a05de02972b9b76a91a3165b3dd81ef8dcbe082496f0315b674045ca2ea7"
    sha256 cellar: :any,                 arm64_ventura:  "cec476efe7624a0475c0713028dce36f4a4fa4b595b7ad100cdd70f9cbc1d36c"
    sha256 cellar: :any,                 arm64_monterey: "0953de184b5b46fcf7c72148b7a3dca7e13ea5cc74e00b08c1f1cb4415bbfb20"
    sha256 cellar: :any,                 sonoma:         "fbbb5db889398aa2df391458cca94c87dedcf4f003f406c86907632c999b48c8"
    sha256 cellar: :any,                 ventura:        "7f7663e6e36a074ab2716cb7df3698db1b1721ed234f2731a5ead4c979baf46a"
    sha256 cellar: :any,                 monterey:       "219e7c3f0b9525862bf15f303a06cb74b6498ec02185b4d1c1d0b0b1740f040e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe1d5442645bc2121579f63c763361874cc4c007accf68723fa04cb9682b276"
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