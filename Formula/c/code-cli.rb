class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.121.0.tar.gz"
  sha256 "e35ec54af68148d70996bcb3bb7d29e7726dee3c01f1a9e4dbd03ab6154b15de"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fefe9f8a03f2c6b08cf2287100bb019ffd8374c78c4d682651821694bd9bcf5e"
    sha256 cellar: :any,                 arm64_sequoia: "8a3eee1c236235444d99040010652dc2b0134a79d8666798655b3ee8c5efa226"
    sha256 cellar: :any,                 arm64_sonoma:  "a0d7ef0900312ac3d27800cb1dfe5ed28c9f3f7f14bece78fd9f061cfd6120ca"
    sha256 cellar: :any,                 sonoma:        "f7e3d945e4306dcb011656a5b5a1ffed7afcf70f19c96da5c7bb86b0ef8424ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3ba80b206d6ddb1f2d484198eada45bb7a4fa823d3eb5c148395f1a2afba72f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce672ca111785d3f2b64173a8055b57714934fee00421a99f4eed7c738437e95"
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