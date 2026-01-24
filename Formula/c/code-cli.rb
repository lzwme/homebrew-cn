class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.108.2.tar.gz"
  sha256 "6b22d80d05dea5bb66e886249419d1a249109122278acd1b557ea5ffa45a4717"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6b783695aa2313ec6b4a6cc7e9be24a537531b0597aa8f45390786a12adb383"
    sha256 cellar: :any,                 arm64_sequoia: "20e3e2491774d32f241cc078e122183a62044409cef57a24b9d4373768fab4f1"
    sha256 cellar: :any,                 arm64_sonoma:  "19e0946005f47adc0905a5e8951aa609f791f882a983386cb818777559fb559b"
    sha256 cellar: :any,                 sonoma:        "f26bf8888f7bf36c51b93df1d93a5da57ccf23c763a6977e71b283d39d344dc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec895ba4036a7d099e0f769083f9ee17a2b95fdaadb11d88a9fb9248e0287f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ddf0c23af30b79b67c4f4dd882d24382c598646512a052ec41b25379772a3f6"
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