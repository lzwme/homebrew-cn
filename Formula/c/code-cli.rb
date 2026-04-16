class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.116.0.tar.gz"
  sha256 "8832058e7e4adf914f28653c0c1f779d24a3cdd3186189276b5c0680f1dc3fad"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f62fb83996d16d9705b1923880702747ce7e9d1a61046c2ca2c816d4c95b0ea8"
    sha256 cellar: :any,                 arm64_sequoia: "0b6ac373786c500d94df048348359b0c8a23cbd6669d083dd980901d50d0c922"
    sha256 cellar: :any,                 arm64_sonoma:  "2609c833596f9968220d3b277cff84006b2a5e9d310e9962c28046d0e9ffad4e"
    sha256 cellar: :any,                 sonoma:        "86a1ef1c29b7ce14b190ee9316c8c80f20d41ee314da7d5f8a4afc5eea71f524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9796513fd4783efd95829631ea3dac4c5bef84052a3fe3db1678387ee03d7562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f219be21874b9fb7cf04f8607d993fff95d1550fdcbccdf51b7e0b193a52763"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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