class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.141.0.tar.gz"
  sha256 "20061291ba192c09c00fe9a56a04c9b33d57caa2605387cd0b9c0b707f47daca"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "904217a5ec509db6be386fd1878144711e442d04a969432e97d5ba34f664512a"
    sha256 cellar: :any, arm64_tahoe:       "155c2877b9ff58b2d98c9f139ae25190f3650393a8cbad6c0480918ba2fe4c9d"
    sha256 cellar: :any, arm64_sequoia:     "981b96f4dd9e92bb60480cfd692de2c7beec762417562b74bf070bde1d3dac09"
    sha256 cellar: :any, arm64_linux:       "66c1d34814fee04092dffbee1216bff3b1fc9450fe8e826f954e1520a6e03a06"
    sha256 cellar: :any, x86_64_linux:      "f13bfda50695d2e4a64938b15f5292f3bf8be8d089d2a6d179676f31b2ea5d84"
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