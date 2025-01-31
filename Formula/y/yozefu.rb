class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https:github.comMAIFyozefu"
  url "https:github.comMAIFyozefuarchiverefstagsv0.0.5.tar.gz"
  sha256 "aa5d2a37292ee86db12cf3d55eca0021c5e88cbe4c6dd05053608aef2dde0e82"
  license "Apache-2.0"
  head "https:github.comMAIFyozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e98197d4216fd161ffedcb5503897006bf086ca93c5d6defa974ede77ac2d57"
    sha256 cellar: :any,                 arm64_sonoma:  "0307f37f8537baa23a987746c0dd0a3dfce7645a72eb18dd06d4b7bdcbe00211"
    sha256 cellar: :any,                 arm64_ventura: "e947e86de3ac7482d3982293038b016611d922049baef493225cf9dcd0712aa8"
    sha256 cellar: :any,                 sonoma:        "4e1356b6ecb5e64fba32db72c5ccc63ba7f00c446dc68ca1e6d8eab43205c5c8"
    sha256 cellar: :any,                 ventura:       "afec265fa87d94c98ad3c4c60b533e3a86c9b162c20927ae979b84fcc33ee31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e741c1477a40ac07133b58bf1c5f7b2a6ae1b2a04131c580a231c1ee43ec74a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    require "utilslinkage"

    assert_match version.to_s, shell_output("#{bin}yozf --version")

    output = shell_output("#{bin}yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end