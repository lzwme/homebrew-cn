class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.128.1.tar.gz"
  sha256 "762a9752a6ccd24d45d8c64ba1aa33fe94b48ab1607473407197cf22247e1f71"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1c9bee94affec0623804a94a980d56d934344f805d78c9d915cbb8e5f3d5dba3"
    sha256 cellar: :any, arm64_sequoia: "6cfc73ab771e816ac1cad46e9da5bcfa55fe691e5b9c1a5310ae6775f9459a0d"
    sha256 cellar: :any, arm64_sonoma:  "979a98fa242f4f4651a5875acae289cb4a177fda09f5a913fbcf68c9f2a7f790"
    sha256 cellar: :any, sonoma:        "e7e95add815ddd5b85d8ba18f0d77feedbda68b9692f4e0db06064d0b7eb008e"
    sha256 cellar: :any, arm64_linux:   "99b9b6b4bf4471ae882ea168692eb5e52dea5fc3b0c638c6d85bb6e925c49f2d"
    sha256 cellar: :any, x86_64_linux:  "03672d4674242e72084c97d08865b2d6ec200fa875bd24308ee6ef35e709ea31"
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