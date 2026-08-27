class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.135.0.tar.gz"
  sha256 "2f8faaa98104e6d2193086c5b769f779712928273a09f05d9cce343be29adba5"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0bcc0632771edefea4e5ddec5f51233d1fab6c3e824ad40049906f335d39c68d"
    sha256 cellar: :any, arm64_sequoia: "c75a9a0a5b10768adba3f6e01db82bf4ebf79c9962f773f95d4c4c3109f88baf"
    sha256 cellar: :any, arm64_sonoma:  "1413f134d7fb11016b26a4ecd350b6845ef41d334d801b2fb7de6caae8e444d7"
    sha256 cellar: :any, sonoma:        "1e19ce2bf9bc30dc2fcd4eb63936bf7cb9ac526ec70544aef7d94bf43a6a0939"
    sha256 cellar: :any, arm64_linux:   "9d7d5104945f18a0f04dbe7a7c0f08896824967a2d518003108fb2bde0d295f0"
    sha256 cellar: :any, x86_64_linux:  "5e11a797a127f06bf5d5ced898b1db9c65624f938362a4ef53f619eebfc060c5"
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