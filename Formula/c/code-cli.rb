class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.103.2.tar.gz"
  sha256 "77d0201a5fd09df066a04a2bc1fa0acbc01317ed62ec04a99b8cb8a0ce2ce3b3"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c32314da8dd27339cdf38d0c6fc1449b18daef15395c2417c75fcc3d58c3366"
    sha256 cellar: :any,                 arm64_sonoma:  "70fd9ee8e97bbd94bd5397638f25a756e732cb2c22f796d006f1d20edd27c127"
    sha256 cellar: :any,                 arm64_ventura: "69dff949fbea6e37d51b52c6969ac1b212f4c3d88568b4249a2d3a7e89eca3e8"
    sha256 cellar: :any,                 sonoma:        "0bafcaabf368b188386ccc62d6913646051f3720ae4abbbb37030271c601d9ad"
    sha256 cellar: :any,                 ventura:       "23df36ce06a5af085eb7897d3b2de7416fdb99f34805dee43f7a9e2342a38ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164547c2467aae68276ed976773d9822a25ef22c625745d26b51f1a6a2861ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3549be98355aea35241ba2c71070bec4bbb2fba14351d06af7d74c6cd86d925"
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