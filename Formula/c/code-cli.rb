class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.136.0.tar.gz"
  sha256 "17eac9b221cdbda56619de95908be073288cdd9c5c17557491442683e366d557"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "09bcc52866bac2328c60b155009546c7dec41174d52fe6f98e5ef1ec0c35a724"
    sha256 cellar: :any, arm64_sequoia: "9864cde5e9890e965b215d5e8e8e01246d3c5df86ab238746d7440bbbd8f89d1"
    sha256 cellar: :any, arm64_sonoma:  "e2002b72354f38a1892105e7c5792d04eafabf4a3b957001569c91e8a392c299"
    sha256 cellar: :any, arm64_linux:   "f82fdc5258a5019bd393f9af21e7973e9b6b2033144c24dac1805d9228a602cc"
    sha256 cellar: :any, x86_64_linux:  "316a4e9c5186e4375be11b27b48c0d03ae0eab6326341d3d3a740c4408827430"
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