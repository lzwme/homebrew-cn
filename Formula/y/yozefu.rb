class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://ghfast.top/https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "f1f2e40926352154d79d2526cded915dbfb4c99713a31f3bfe52b094bf586e2f"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54734348fa9e511d1d070a64f41bc64921f632210439e97a58ad7dc07b2a8694"
    sha256 cellar: :any,                 arm64_sequoia: "d932ebb8bf2118d4b2d25eadb268e2fd9a159a8f62ce2f458d01e22d2a788805"
    sha256 cellar: :any,                 arm64_sonoma:  "7a5dc98e43043e4e71e99e4890685f96a72d851d7f59d6e4f0a6534668804f53"
    sha256 cellar: :any,                 sonoma:        "009cf958827cdb5d50fce29c607bc93d8cd55f54e3850a7fcbf8188929f6f725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77b74299f71094a9a189dc3764a3027b2816f52006c6aa88d674fd0f9e8b80ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2a8c9ad7a377ea66e2bd0de2a6c403e3b1ce8c7fee149e606d29a8546b51b6"
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