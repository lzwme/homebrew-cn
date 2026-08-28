class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://maif.github.io/yozefu/"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.32.tar.gz"
  sha256 "ff2b0d57fe8c26a7bf5c957c341e2db3a0c98f1f271085bb8bff2bfb934fcf2f"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ccea35c1826b98532dd9bdb2e0fee969b168cb52b92cae85cf93604f5e7da50a"
    sha256 cellar: :any, arm64_sequoia: "4025065f6e88b76159733b5cee242b48e523545cb8b9280292812cd21490b3a4"
    sha256 cellar: :any, arm64_sonoma:  "652e4925e840a088e48940bf31d725c29f805d8c9b80c42eb94298ccd4452b0f"
    sha256 cellar: :any, sonoma:        "edebde23a8538c3a486bb95f999dac813eeded3aa8fc54d03769b2bfb74aa5b6"
    sha256 cellar: :any, arm64_linux:   "bdb7c72c626fd719deb73ddcfb891ccc86a3022ce8ead4733f3e691efc4c3081"
    sha256 cellar: :any, x86_64_linux:  "94c1a23e26674e449974d511ec9b21e05e9faf80231f4bc093d386e1e86b3fcc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end