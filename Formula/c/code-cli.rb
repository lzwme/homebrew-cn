class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.101.2.tar.gz"
  sha256 "d65d04e68ae04a372b1c6b13d0e8a72e2c919e491d4c3b2dcf997b22fc25a509"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44fd128f7e18b35cd6f0f47eaa3953bd94a51a82fa1d8697fda9fec3b764cdb1"
    sha256 cellar: :any,                 arm64_sonoma:  "21d702fd15200d698924d91a6a972261c83dcfe1903510f530525b19e5b7110f"
    sha256 cellar: :any,                 arm64_ventura: "77d325b0471fdef98198b6676533c710ceae854b9b0f9ee866e99f53a8020e45"
    sha256 cellar: :any,                 sonoma:        "242985874d51f0901a5e3ca3472b154bddf21aeae96a41bcb2720bee46f85ddf"
    sha256 cellar: :any,                 ventura:       "6fb744472babc35387fad14d9d506799360110963191167af84dfb559de5e83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3015e0ec4ad247019eb531652a06bb0d7cb6ca0e70474e454bce024b4b7a8376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d83e8435bed81e775c7c9c7393ef5e9c0e29d68753aa15322dec75b371c3c8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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