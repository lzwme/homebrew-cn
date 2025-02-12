class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https:github.comMAIFyozefu"
  url "https:github.comMAIFyozefuarchiverefstagsv0.0.7.tar.gz"
  sha256 "5f2cb15aeae39f2f623f680a826baafb601ff0303af102e324ed5de0a2c0a8bb"
  license "Apache-2.0"
  head "https:github.comMAIFyozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d871c20fc10df573d67cd72ff30e4fca6b83dba106137c423e39a049a529098"
    sha256 cellar: :any,                 arm64_sonoma:  "700bfa0687e5668577136955227fa4530321285bfd6a9fe0380051b0b6a535e7"
    sha256 cellar: :any,                 arm64_ventura: "16ff1dc1b65caf147170675c355cc2161ad1682d689216d8159f4dc21586a167"
    sha256 cellar: :any,                 sonoma:        "c46226fb0ea16e17f9959bcce5562cb4f2468409c5625bce045f7798de8cac6f"
    sha256 cellar: :any,                 ventura:       "850e8c4b4515769b3298ad18caf0d3b77ab1bbeccbc069b14669f1089defe4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93763abc08ae98fd0100dd89b2b798f88b82598a896985e4b8164d3800f291ac"
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