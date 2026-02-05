class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.109.0.tar.gz"
  sha256 "0f871b8c6ca75db03caf32940b9e0904692df19943d6f3e2dc07107f87bdae31"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0168be38d839b6a852fa1458285f5628b0400ab0544eff7f4f17e4bf50df41cf"
    sha256 cellar: :any,                 arm64_sequoia: "c24f0b70aa3522ff1b80d1d1f69aa58bf8e4b047ef22dee9867b949c2d44afe9"
    sha256 cellar: :any,                 arm64_sonoma:  "6263aa7d9f13463ddabc369e72c14198e3d3e7fe94c310fb83e36e3babc6fb43"
    sha256 cellar: :any,                 sonoma:        "71e55481b306f79aad9836f9abe7c9a6689c00e2899af024ac9b758e2f91d0ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3facf5ba64ff6d049caf2c7a2fafe3f0d1ddff3d28f9c7789697e5f6053530b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7c74a4d5e3ba0107f9a2a46cf29c750486c9d2b40588bcb5401b7b95f2f774"
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