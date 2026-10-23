class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.143.0.tar.gz"
  sha256 "eeb672f3aff0917a1f6eaeb97b8dad5458a9a0ed54404f4aae3d51f7b32b75f7"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e586b8e128b48408ba56372c7275695ef81cede1156b3a1e2db4fc307c71cb0f"
    sha256 cellar: :any, arm64_tahoe:       "21fa943ea527988244a1edf8a816b03ff712d14c69180a8dd36d4888bd8003a4"
    sha256 cellar: :any, arm64_sequoia:     "59240de7246d7a059e6a6b2346b185d9210a8231ebe0df2314f29e829980ddf9"
    sha256 cellar: :any, arm64_linux:       "925f9a3088da257e4c5c0625bc4f1f29fdda5de75df3d66843046dbf36c2ec9e"
    sha256 cellar: :any, x86_64_linux:      "51b3c9431edd86ac5722999d9d2c398666b97c3bdf0263c1de9b2c576c539b1d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    cd "cli" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

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
      formula_opt_lib(openssl)/shared_library("libssl"),
      formula_opt_lib(openssl)/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end