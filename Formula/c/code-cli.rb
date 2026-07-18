class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.129.1.tar.gz"
  sha256 "d129223a0af5113ff14de88268f7e475c889970fb60272df937b47a0c38c1adf"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "990aa338b3d5b6d02a5c9c0bbf7eecac09b1ef0c054e2b34e467ee34c965c986"
    sha256 cellar: :any, arm64_sequoia: "0e7d1f1839ae589bf8364fa208c550b978f3ad4100d7e04d2ec082598500967e"
    sha256 cellar: :any, arm64_sonoma:  "585711f0b9ded943bf33f26638c6a2321b0c933921abc6b2b763c884a39db830"
    sha256 cellar: :any, sonoma:        "cd07a7e3d7c69e02f9e10175617713f383eda64a76f574c0fb1ddf1172340610"
    sha256 cellar: :any, arm64_linux:   "1d9eeb2698a85a3ee9e0449aa37b117c7781d92d44e05c785fb8184206c2b429"
    sha256 cellar: :any, x86_64_linux:  "81f6207a592eabfb5f1905fb9da8b0cb09f3671d44b16c6ee44e795d3028ba21"
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