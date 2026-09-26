class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.139.1.tar.gz"
  sha256 "f689a6f14cf87903e5d7cc777448c46d5c12ad36f3b49ab2747b9a4acc1524da"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9efb8d1f5cc7950b8136f74116e5d73bcd77b1e9eca1afd0eabd16b69714621a"
    sha256 cellar: :any, arm64_tahoe:       "d5b331c00c533b4c7dd423823fe2251c9d011aa93d43aceead2313c532ca02f5"
    sha256 cellar: :any, arm64_sequoia:     "22c3bb7824c1d54c6bda6d1a8ce14f707e07fdc64195967ffcea6551b4c69560"
    sha256 cellar: :any, arm64_linux:       "cffc88c216147a992c65818a1187e9a9156f8224fce21622f55fb1389241a852"
    sha256 cellar: :any, x86_64_linux:      "3baf186297d33322b396746a62f769bf3fbb97df171b0492c7671c2fd71ee1f5"
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