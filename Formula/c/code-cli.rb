class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.124.0.tar.gz"
  sha256 "26d5723305c7921983b15baa1e6793eacbfb4e7e9a3beca2bdd30996fa120828"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e913888a5c023caf54ebab88d4390e33c9cb5c08b78612bb7f84e17de134e0e9"
    sha256 cellar: :any, arm64_sequoia: "4b8587bc1ce8e6cd1629eae2bf10c7f76b47d5da53eb2f2ba46db1e4e83f7b63"
    sha256 cellar: :any, arm64_sonoma:  "84929ecf84f6afbaa07e16d60addbfff5f64031315161d5a7ae61f2b3eba5467"
    sha256 cellar: :any, sonoma:        "8fa02924ef69350d8bca083a1cb4f18aaf1aaab892c5deb04e8888da58c8b34e"
    sha256 cellar: :any, arm64_linux:   "45ca066b0c3ea7a8a1d6d0bd986134ca506d16d2e02c55a52ce1deee518004e0"
    sha256 cellar: :any, x86_64_linux:  "78e5a240ca893e7400f047399aaf90abc4bb3e0fb7c56f6cea0422ac3cc405b4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

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