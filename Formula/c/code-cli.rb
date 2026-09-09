class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.136.2.tar.gz"
  sha256 "bb278371573dc21551dcc0c0c4a0498054970096b701e43fa8c6f8c54799893c"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "94f5011ab6761eba645a12e5adf7791dc3f76efaf99b16c603bc38fad829c734"
    sha256 cellar: :any, arm64_sequoia: "c35056759941924b7d752c138140c77a9216710a99fb9f131efc1c00e4b34ac6"
    sha256 cellar: :any, arm64_sonoma:  "0ec9d23fb6c6e91c31b7e5ec050bfdb09335fb4e5ff9fa7d5f2a94f5b7b5ae3a"
    sha256 cellar: :any, arm64_linux:   "b489fab9efe19af4958397239921a9c40d12907b15b0a47984de7fb6af2b1b16"
    sha256 cellar: :any, x86_64_linux:  "608cb59e6c7124796f9977e75544170de2e151e96045bd63e7f92b34cb9c884b"
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