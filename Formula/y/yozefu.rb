class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "ded11d412c3977eb473cae8b2cd11f8aa9c260122068200f50465c99334efc31"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2f8f84db9acf41def4efc6e72cf6e19ed50de6e4bb95b8be447d197941bb4ca"
    sha256 cellar: :any,                 arm64_sequoia: "6230c71091916106ccc3c6cf586591680d75f938297449c8fccc0cec95695ecd"
    sha256 cellar: :any,                 arm64_sonoma:  "a6db02a7f966a64e04a7600221fac70d895039a94823aa496150bf2eb666ea3d"
    sha256 cellar: :any,                 sonoma:        "8cbf1752b13983269bca0cef4cef1d1e407736842d33a0d81b1479ecbbc10ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dac469948a491711f62b10ce424dd8b1a93052fcac18a359944395a9a47252bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40bd4510e0190f69d01f520f6400b746bbd236cdc4d6f71d4ea25ced30649efe"
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