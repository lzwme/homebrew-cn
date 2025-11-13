class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.106.0.tar.gz"
  sha256 "71370e45a9daededeacc1139ad6b71518e885e96acb8239387988e1fc59dafc6"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b14d235f05276beb7e797ce03518e5a2c885af3c37df082a8833b580491d17bb"
    sha256 cellar: :any,                 arm64_sequoia: "43fdebbeeff624468ab54983b1a603357f8039e6b8124a4232a9ebb84d5585f9"
    sha256 cellar: :any,                 arm64_sonoma:  "19b41a67b8ec9d699b7e21485250a211fdca5a3ed9c68d004329fdb4dd8ce1c9"
    sha256 cellar: :any,                 sonoma:        "33cfd2f5c6e32d4f3a8913bdd3dbbd677961dcd23e1cc24e0880314c5d36fa0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "799b9f886f395d1230f88b4b629a905b9a8786c02b21baca1b912267b59ea99b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "406777ba46fa434823c1c6c4373f551fd264e9ea9650d19dbc6e441907d5fb8f"
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