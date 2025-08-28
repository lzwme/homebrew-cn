class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "3278f215b825bd583e783ee158d23134fee37ebc91fb9f7b648add61a6c82431"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b34d677dcb57b39c168958e89021bb69d9f80610b7460c568272e8afd37a3fe1"
    sha256 cellar: :any,                 arm64_sonoma:  "960527c79b463125c2eddcd28fddd1da8dc0cb9c3816117ce2695f3092b0459c"
    sha256 cellar: :any,                 arm64_ventura: "f667cc69a4d78b5e210b054703a3ac68f5d1212116bfddc37996b4c94d246e79"
    sha256 cellar: :any,                 sonoma:        "9fb095d0a8cf2708095bb1eccc2d622d12ff51750262021e3c6e610726269fd2"
    sha256 cellar: :any,                 ventura:       "c783584c76fefaeb10acdeac0ca5f795e706a3f7e4a671e6120834758e660dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2fa38c0f170ed25d0645856fddeea4b3510adf979b7066f3a7f2a2efb468274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31e62d4b177daca57cf92125f4bad239373956709b98f52f5118d2a95a5d1cf0"
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

    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
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