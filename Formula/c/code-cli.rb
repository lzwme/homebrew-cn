class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.125.0.tar.gz"
  sha256 "6fa57b17a1860c2d17e46a64273991069fddb1057e98f51690496a0abddda5e0"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e39a17ef3df9b14a03a9b591cd8b64015a1e0544c265199f9527d343dbf1ebaf"
    sha256 cellar: :any, arm64_sequoia: "f55220a3739c59fd02ba499582af2debca83b43af3af8df9dfaa2cc349cfe0bc"
    sha256 cellar: :any, arm64_sonoma:  "908b5d7f6a30076e5be23e859125b6773aa85fe563434f8cac5ab143b3efa46d"
    sha256 cellar: :any, sonoma:        "05bcf75da507d8b03b6e391a0c0af32353276fd56ef621a516dc3a7793a3766d"
    sha256 cellar: :any, arm64_linux:   "89935c6d031a6fd5ae978a1c98381bf1212df12f54d422bd64b465afe2c1617c"
    sha256 cellar: :any, x86_64_linux:  "4feb13cbefd2c7f5d92806c548cb29664865bbc329967dc37529df508dcc2129"
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