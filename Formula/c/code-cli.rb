class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.98.2.tar.gz"
  sha256 "e33c5e245420e877eca378103661d99ee768d6c21fa9bd690a7171b32258d6da"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a233ed7eac3371ade2d6ab877933d9234183a8444fbe101fa9df33eede5539c"
    sha256 cellar: :any,                 arm64_sonoma:  "78ffb2290dd6700c169c4447c31c54b42bb3298c76a9c74d91c1daa7f1b0e705"
    sha256 cellar: :any,                 arm64_ventura: "4f9cf9b13717a17cc645245e319e1df64505335a7710cbb00c223ec83ab89d87"
    sha256 cellar: :any,                 sonoma:        "9d6901f4875634688f1f52dd110f2c941c42eced7d7b6c27e57e3200660eaa58"
    sha256 cellar: :any,                 ventura:       "76d9f9d838c5edd55e6e72bcab440f65480409b033f36f82e9b4a5824aa4e226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c2775fafe3cfdd50c16a36069e23ce620d68134e8bc3eebc78ee970586ff76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ceb6426ddf452a38abf3a31f0be1d169e3501d5b295a9b8e4fabae3b28b6237"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https:crates.iocratesopenssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utilslinkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end