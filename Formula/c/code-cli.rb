class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.106.1.tar.gz"
  sha256 "e1dfe73cc45ab0afc0e64c256d59d1e278ce82afb36e6ff84e0550ec125ecdd6"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94fbf2704e1e0f1eab529b7c5b182ddbbaa2e0b51e91ec3a35892b6f39aa7a7e"
    sha256 cellar: :any,                 arm64_sequoia: "5688263adf6da49f39bdf1e7a7800def6214204f1c93ee713a8ed591aefc7584"
    sha256 cellar: :any,                 arm64_sonoma:  "877c6caad38b9fa75e6e87ab0da5d2001816ca5f8ce26714e1a22136ede2377f"
    sha256 cellar: :any,                 sonoma:        "5a9fb7da89378fa8e15f6b00bc0ffa3af8d174dca6a378fb5d9e3933d30f8d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "072a34d42b947fd1723e384f622a5ce2f6712c4b637ef618fb66b23ae37d7c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c227ecf7bb466232ce4a2d188e5284a51ad4fb9fa5ecd038a74c432a77bd220f"
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