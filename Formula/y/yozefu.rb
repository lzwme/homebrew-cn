class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "58d70ebbef90053e90690f15270cec225ec90767a3674565d90429801814f5e4"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6d986ff3f6b1367db0c55d643a9dd6d431ef9dc24ab7a36005cdc1f22eb784c"
    sha256 cellar: :any,                 arm64_sequoia: "ffaae0befc5386001b25d85bcb7a871457653e510d17f34ef5b36ece8a2b5a6e"
    sha256 cellar: :any,                 arm64_sonoma:  "ed6e426f4b3b434979f78e40a4af564eba2ba411a128600f139f92eac9017644"
    sha256 cellar: :any,                 arm64_ventura: "1ce78c6fd6264538ef59d4d31edc7948845afb2a495c1e8370f5bd67ca8d170b"
    sha256 cellar: :any,                 sonoma:        "27e3715c233a383eff0b5023b9f92abfe16109f01ec64dc8aafaaf87595288ad"
    sha256 cellar: :any,                 ventura:       "9712f5f756d384fecd7697c6ad483ef54febbacca40af128f947c4bc735f43ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3612d8ac038841a3a32490a923a609e66b372f5b550381d0da192b7f0cf8c0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389c97618cf474e923f6f6dbc445158a77b5db99007199ffccb4b7e88687b825"
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