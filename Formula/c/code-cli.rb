class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.118.0.tar.gz"
  sha256 "a7ebd8f47047b309e2823951799295bda418e0b784146e72998652706612c4fc"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a028076e46e6d89d97a414849c0cabf34c6980be5e264e6319597cc1055c80e0"
    sha256 cellar: :any,                 arm64_sequoia: "0f36aadd0fff6db871dc77e664f58a906d9045f5fd7fe8f053504fd38bf3d8bb"
    sha256 cellar: :any,                 arm64_sonoma:  "e6eb6245558513ce120c65f6dd3cd482f3844a2006ae76859044c67e8dd0260f"
    sha256 cellar: :any,                 sonoma:        "b71582c775e63b026d922987321b55a124a2eb8efda6e068a324e1a7a22bc5d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1e94392410039807c8ad5422d778267b9c3ac32e35201dd9809a41ef46e54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "791293b61ec2354f992504cd16432e0dda2269c6fd5d0969e00696fcb65423e8"
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