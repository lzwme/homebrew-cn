class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "a09b0e8c22f50a9d0e90c9f27012d2070cfc17542373c0ce43c67ebca1133ead"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0798ec6ea3136fabff0959fc913df97622f15dd945fe03d3bf6cf3ab8978a3e"
    sha256 cellar: :any,                 arm64_sonoma:  "6a9a4bb19fcf63490902ff9293dfd04c2af4c27cdfa7d7bde839a54e27d3b0dd"
    sha256 cellar: :any,                 arm64_ventura: "8e80a36f73c977341422eed07576c2610e3d6700765cc9959994131fdef3cea6"
    sha256 cellar: :any,                 sonoma:        "7eda9b4127253c2fda494fa12757148b360f052c426edb319b3e7a141f0ea70b"
    sha256 cellar: :any,                 ventura:       "570306dff471b9ddf1b73bb815982e779dc22836632a98f51dbb53a590256a71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e888796d3eadeb205082c0b6ba762d541187ba502e913e7d1ed6b2ad2e2bb629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b0f0a3c2c7da38c7c7b7b23248348ffc78da6d9b30ad0516681fbe1b2afb77"
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