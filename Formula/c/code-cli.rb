class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.110.tar.gz"
  sha256 "c74d1496b55db0c54b082968ff6b73a581a8fc3135e25ba29675364102b3f689"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "209450b884b4598ce2a0509a3e44db19131fdd90f0e9226cd3d0c663c2733751"
    sha256 cellar: :any,                 arm64_sequoia: "09ade9afe4bfbc2620ad4ccff31ffac0fee45fcca102b7cbb5050b887c4c00c2"
    sha256 cellar: :any,                 arm64_sonoma:  "a92c4dc445da0831d5b592d69c9f23ecf04697ef9c63d3f66cf8b9b3e35542fe"
    sha256 cellar: :any,                 sonoma:        "7881546d3e01272b64eea9f984e2e1eea0f4882ca9497d0889be98a0795c7f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1804b87779b90418be2f9b55a9c9fdde2ad8d11fd1382ea82524a440bb37af87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c319ae246ef73c7489ba567b535d46fe8fde223d88c5af3ab396d838a69cddb"
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