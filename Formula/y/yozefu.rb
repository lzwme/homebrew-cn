class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "20bc3c9f88bde4595ac658ac4d4929b214a9857971d0427b24569a4cf2766762"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "971c80b2402ffaf7464a74b68467833080a5b47f3268c8b9b4e257225605c02e"
    sha256 cellar: :any,                 arm64_sequoia: "70f6407f1531c1a21583a48563e72c05f389462a9b43704702fde9230ae0f797"
    sha256 cellar: :any,                 arm64_sonoma:  "d1f7f64081cabdec187355a24b6cff1459a9a16432d7119e99f7e626aaa20410"
    sha256 cellar: :any,                 sonoma:        "04c4dc08d3cb435705442302cd4e77fa24daddd07ae1424112752260fc6ae421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe2d3197fceada7340ee3bc9a40df5d96fb3aa876a0c1e4313f47bccd01b430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb89838312847f4e2b58fe4b9ca3fc63a77ef0b5731647fe9ec6985169584e2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end