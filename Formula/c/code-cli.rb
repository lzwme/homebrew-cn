class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.109.5.tar.gz"
  sha256 "a61f685cfc3678dffadcc3cd898b9250db46e6b6fc0dbf76f8ab39500246ce44"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de28eaa224d9e5686930cbfd1e03e51396c494f3e8e5e0408ade070c615bb786"
    sha256 cellar: :any,                 arm64_sequoia: "c2eda65ef42d657067a4ad5d2eef7d8002dd8de12fe77330d6c3540a34ae07c9"
    sha256 cellar: :any,                 arm64_sonoma:  "3b984dbcb4602f1d11799ba4db736f201ae41840c15000969f428494bd793f06"
    sha256 cellar: :any,                 sonoma:        "6e0f884b2fd97765f1e4ba82dffe3b41cce38b1d309ce1148c78956372f6661e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6107deebfdf51b80fa8a6d75f4b48e0b5b436ba892ddaa40842109baf1c8937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbfd817b5f8ce5f07589888aeca2603e4b4c8da0f66c78d4933087c5e9d68dd8"
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