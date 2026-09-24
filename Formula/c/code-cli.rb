class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.139.0.tar.gz"
  sha256 "77a9975246228ec09fc01e0026727877a73e88a26876d43517093b451575deb3"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d6dd69feeafc6f0897a63f1b0d97a3d868ebede2572a78a6c8a10522b43dce5f"
    sha256 cellar: :any, arm64_tahoe:       "58750d85054fb84e4fb6557b828ca4afd4e912b05c3c9307c3f134448cb2fbcc"
    sha256 cellar: :any, arm64_sequoia:     "5a4634178ba5be08dff6baa001de150794cfb64196f096067656c2ac5232a884"
    sha256 cellar: :any, arm64_linux:       "ac61a3c28741bc9e42ecb2f9106a03fe6615ffc8d81f7e7d473cc136bb706647"
    sha256 cellar: :any, x86_64_linux:      "20594212824442c1737e4c1ce066c021904edca42f7258f1e378fcc9aa12a76c"
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