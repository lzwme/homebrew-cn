class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.132.0.tar.gz"
  sha256 "2eeb9d15caa4d74ecc37078e30ba822da3b4abd4e89eef2fe6ad20f89a5deb38"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0592071785b3efd09150e6f0d763c3ade3e49270d4287f4bd5912689e5ef7173"
    sha256 cellar: :any, arm64_sequoia: "ac2a2416c744faf946b2408ea60d987c8bd1a960b86d3216573c1b6be50c3f45"
    sha256 cellar: :any, arm64_sonoma:  "1119aa26cfd76b043dee67850d74e5d26dda64224d4e5da0673ffb410c8395c2"
    sha256 cellar: :any, sonoma:        "570ab0f7472a932e38ad14f76350eacd0a1d380fd1eeeceff67308235de5dc58"
    sha256 cellar: :any, arm64_linux:   "42df4c170fb422db79962c2b068dc98faa12e8a468bcc2d888a2ac8260a9f0a8"
    sha256 cellar: :any, x86_64_linux:  "fce50c8d0dc27522244059fddc717612bf513600ad42e1c296cd9071d464ccea"
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