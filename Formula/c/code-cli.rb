class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.109.1.tar.gz"
  sha256 "fd473ee592b541f4f953e9accb42e71368ca1853bd965ba98a94c3f94e11a7c3"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64b93c90599e32ebf2b42896ebdc39a2b65808c5db4de39095cbcd93e8026cef"
    sha256 cellar: :any,                 arm64_sequoia: "2b000f609c61cf5a064a80f2a33cfd464e23208d46e7dcded744f59e73bea00b"
    sha256 cellar: :any,                 arm64_sonoma:  "56df98d3cff250248b66b03c87b90c5630587b6c1530afb180676a38cd91ff33"
    sha256 cellar: :any,                 sonoma:        "88af7b656dd753f5633d5187a12cf7f550daf273b331df74df1f458e8c212783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6bb99712688f594cf64e243846c4a7298f0ddd0300410908b4d74a8c2258ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45da74df1a5474989c3cda0347eccf8e4c599c241216c05081e5d259ec2d3e1c"
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