class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.102.3.tar.gz"
  sha256 "c9421e92e30cc8528ce3b31acb07c594377cc49bf9c5f30915447b9af97aa96b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0808bc43bc5cd0e60467a599f5815b8bdec9015777140614a087364342038ff"
    sha256 cellar: :any,                 arm64_sonoma:  "cf52ef808973c781487efadd489d2f39047f8c75386d373469b062b2cfedfcc0"
    sha256 cellar: :any,                 arm64_ventura: "aae40b87b0240e7afd800d069da860bc98110c499bca122f96ce4b6ede591a2d"
    sha256 cellar: :any,                 sonoma:        "1051d28a6724258c8e4adeaaf6c35fd086051e9b6ae01dc1e96c6995268d4afc"
    sha256 cellar: :any,                 ventura:       "873caad76f12367a3112b8e2fc15e8b26d9a28bbbef4e2eec51216574b5fb92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71eceddbed8d36cd2cd2d11e534fb286c6ad419a1947ed8aee8ad91b36352eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ecdfdc150dd49d852ca77c3436dfa9184d5b0c6729837e704b5950108ba0937"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end