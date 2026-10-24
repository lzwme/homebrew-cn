class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.143.1.tar.gz"
  sha256 "d0aa0fe95602998ecdab87a1f51139455b43486a3a8b50f7f62f6b459ffd31a8"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba95a4afd216b2d5bcf172d0d27c7054d8a3205ae41e6db98809d311efdd98e7"
    sha256 cellar: :any, arm64_tahoe:       "63f7675b12fc1742479807a1290ee7d2140f416939a5cc05932856c3545ea0f4"
    sha256 cellar: :any, arm64_sequoia:     "864999032f7f995267c7a404647d2bdbd43ad557fd6465616dace28c71f9597d"
    sha256 cellar: :any, arm64_linux:       "6254749aecade1170df1d4260b817419199707fe69a41741948abf4b1a117260"
    sha256 cellar: :any, x86_64_linux:      "ed967cd01875cef76f87b36549f465e9f805043446c066aa0b9cf757a85c4a40"
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