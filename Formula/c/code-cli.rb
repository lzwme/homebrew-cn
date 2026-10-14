class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.141.1.tar.gz"
  sha256 "d6933b37851c18c410210fc06d0844e06b12e0971ddc67fb939ce5684e276b63"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "757f97da635086bbf5d843ccf149bbceb2afa84d0038eae73c117fc7e8db8397"
    sha256 cellar: :any, arm64_tahoe:       "9104f91b48b72a5d108b7a148e0691bd54b60a9c03b29c7dc955a4474eba7a34"
    sha256 cellar: :any, arm64_sequoia:     "fae0411b4ac89c17dba17396b8204b65879aba7833b27d097d34cfd285372343"
    sha256 cellar: :any, arm64_linux:       "c7c93f04ea85be76289f1470d08b6e3d72ca9657a4b413c30cb8f873c8205fa2"
    sha256 cellar: :any, x86_64_linux:      "1ec8c4fec6f5ee95f61683b5fc4e77d1325dce58a30534ead048fa59218bedf2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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