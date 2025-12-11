class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.107.0.tar.gz"
  sha256 "6233b61cb7b5f62eca82de2d2c6c960eaec4bccbdc27ed00076eb34dd27939e4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8e2f7f9b7948c1e3b3bb0ac92c4d95b8204c50db0c01cb66bae550735ab2ca6"
    sha256 cellar: :any,                 arm64_sequoia: "7a0426200426ab314429a591b7c180b9a48d39756151c6f9cab4c6dc488944f7"
    sha256 cellar: :any,                 arm64_sonoma:  "67410501cf635ee2645336861e7c420f7e76d57a270b557ee2c10d9b89e18a7c"
    sha256 cellar: :any,                 sonoma:        "7ef048c134200ac13787552e570310c33942aaa42ae087da4f3dcbd11e7362d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac3ba8e076eadb45c2b58777c6698eb4d70d68b71ae63de5e5d408ee1e277feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fde3e586663309c71cd9540be0f2ddd93a0311f1e69f43c90f985c86e9168778"
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