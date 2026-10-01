class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.140.0.tar.gz"
  sha256 "0daa0b2b2c2e83b57be7fa1c4b8163ad4846735063e3164f06b386176176707f"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f49fee0ef956327ddb8bdad9a3a1bd56c74c7c3833936ea626b90f2ee2d0be9"
    sha256 cellar: :any, arm64_tahoe:       "cecdcfcf160fad6ae5af1c796d8adf062b78e0e55a026dab11e883881947137a"
    sha256 cellar: :any, arm64_sequoia:     "c612d4d74aadf2d734b4b8cf58898f4e16380aec82242af2ebdf217bd18a9897"
    sha256 cellar: :any, arm64_linux:       "5d4e218d397be4b65cf10b7544e8b14b42badadf9653418a175b85a203a8a1f5"
    sha256 cellar: :any, x86_64_linux:      "bb2360a50aa4f11f21339c6a1e9347f002191aa4701c4cbaae002b1caaa060de"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end