class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.122.1.tar.gz"
  sha256 "d7dc639c5c10aafa41b735c48d4b9347a19afb03ef6af3277a6d6af8b711aa7e"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e4e3b17b3367a9a8e52cc13e6c784eff8a21b61d2dd4acba021c79eeba31738"
    sha256 cellar: :any, arm64_sequoia: "6da281bceaa8ac2f2daf3dd6820437948d44ae19bf530622cfd1bbc8c1e767ce"
    sha256 cellar: :any, arm64_sonoma:  "2e697a9b330bd9b548776d947281cce802fba568da3774d79ed43b3ae73dd4a1"
    sha256 cellar: :any, sonoma:        "611151bb15c7b65dcbdfc279e6d727ffba83117f3a0a0e0dbc1feda3a3aadd13"
    sha256 cellar: :any, arm64_linux:   "93c4a81bd8af4da69df1bc3ecd2def2dbf4bdd42c32e62dbf2f8d5b111a1ccfb"
    sha256 cellar: :any, x86_64_linux:  "16115fb2f4080a4ecfd3cdadd6fd27cd932485f61d8ff8ce06a1fb8103fa099a"
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