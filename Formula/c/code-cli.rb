class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.132.1.tar.gz"
  sha256 "a02b704b22e4e81a93e8fca8e8f6ad3d9d770c877ba544a294aaa42a5567c8e4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "79007ca69005ce5066f2e597a98c664ea0941b4790aa468b7fb24951344e65f6"
    sha256 cellar: :any, arm64_sequoia: "b882fa7494271372905417c4be64d77d4aae60eecae48319fd495782fc35c04b"
    sha256 cellar: :any, arm64_sonoma:  "13decd0879f03a146d58b70c671880f780674566ffadaf661b34592ba27ab2ec"
    sha256 cellar: :any, sonoma:        "5ce711c4b85534b529aee556c763f1d8e2425566a8f121ae4934c431350dba57"
    sha256 cellar: :any, arm64_linux:   "100eedbfea4bfe3c642ce75c4058e156ea57d45f80c305cb4712baa1dd9fd30c"
    sha256 cellar: :any, x86_64_linux:  "278044d0c52f9830e234958c41899471b6535b4e9a889e645b26e8476d967c49"
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