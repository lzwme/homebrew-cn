class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.131.0.tar.gz"
  sha256 "fa2addef0f8f0c23b3b93a08ca0838760b1cf3483104299e2297700c3a2d31cb"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4d997f04824af16e8375c0419112259db68eca66206c0bba9997285f4fd5278"
    sha256 cellar: :any, arm64_sequoia: "07d3ebf5c4246c6018a2b07d3b5d4c953abaac8fe6c1663e7b9b71a87153a977"
    sha256 cellar: :any, arm64_sonoma:  "cc8c3d268b971f0fff8a7d429e211d9fd53cfb84c5ee921649fbd0845c493219"
    sha256 cellar: :any, sonoma:        "d1fbaf42a46172f801853ca71537b937448cbf3dbb4e7109f5c41573bdbc9018"
    sha256 cellar: :any, arm64_linux:   "4cd74e1aacf34d94bb1af6704cf27ce2c2ea135c754fb2745a82ed7323c13022"
    sha256 cellar: :any, x86_64_linux:  "68616fb9b2a4db85473b1dffa2de7aa175995f959f16127d4c160017d55b6665"
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