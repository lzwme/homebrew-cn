class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "efccbb5c2bfbc80db836e3e43849ae76b67932889a2b9f076563232b7c39ef24"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d5e9f2d96dc66253c6a565826335aba3f226b44da66f07134e7370189fc6fb8"
    sha256 cellar: :any,                 arm64_sequoia: "60ca63b39f1aafb66cb6b4d283a91817bb4add4970c60b7ea0e76a4fc2459816"
    sha256 cellar: :any,                 arm64_sonoma:  "e26c7dbd95b29dc36229909fb8c5f39fffe276e9754e8b6c056d2fef4a501002"
    sha256 cellar: :any,                 sonoma:        "da73acaa6f7472447f8d5527964036150e37f3a833900af02a6dcfd76ced49c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde14a92b7254d2460357add21488f71ea717e570e897cde8194a8d2584eca05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5670016f9fc500fe8933e5748226a13af8bf870acda3f39ab4bd78c97c45b3a"
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