class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.124.2.tar.gz"
  sha256 "5b7e4b127a6243f315bcf43a9929677efe987aab4e8496292011a2e71a900e51"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb02dc38e1952a182530e58166a6e7d2df09073dcae75b83c1d5f7f4db2de90a"
    sha256 cellar: :any, arm64_sequoia: "dc5460e59e6571af7e9e5b7c6060a8343f81508d654daec026ced08dc27d5095"
    sha256 cellar: :any, arm64_sonoma:  "58f1947a078ff8ab76d6c0a6586c35acb509f534661cbb3242cca38d233e4144"
    sha256 cellar: :any, sonoma:        "ebc017f15cfa89153f08fdb9a8c69bd7e1576516e1d4dbda7f8abfdb65185e46"
    sha256 cellar: :any, arm64_linux:   "bdf7904027dfddc06c99cdc6909e4ca27d1fe92a429d65a2872cde6ad6738017"
    sha256 cellar: :any, x86_64_linux:  "e38d99e33708c1d2efcee1e45952626f866d93eb789859b3abc511789061be76"
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