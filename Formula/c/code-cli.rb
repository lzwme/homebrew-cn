class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.129.0.tar.gz"
  sha256 "ee2eac3025aa8f55855fb063954108f2d79f2d0b27538eba9b6f6514db5de846"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6ec294f5adad1e3c45482594b4babbbbabba2530ec1aedac60ce58f52005d6b3"
    sha256 cellar: :any, arm64_sequoia: "2933b28761ad28b0719f2d41324a8233bfd243d7385f2802069806e37989e19f"
    sha256 cellar: :any, arm64_sonoma:  "c191dd94ddb238958d06be91640471f11d5756e730b160f046247fe6fed21ca2"
    sha256 cellar: :any, sonoma:        "9d08aa2c2377f7a142b5e55f910bd4897768f87ab4b6804b3e0f5bdb699b9d78"
    sha256 cellar: :any, arm64_linux:   "bfabaa03b7666c255f2df52c172553dd86f702171b7b372876eb679ef47cc341"
    sha256 cellar: :any, x86_64_linux:  "1631dfaaf8ef395f5d1e14e0e97f5b23576b9dcf4af28d6878461295d91eacf1"
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