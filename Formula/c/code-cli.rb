class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.99.1.tar.gz"
  sha256 "c3f59e9d725beb8c6b86ea121e9ccdd01f1ee28c5a7cb2237d82e1288d474c45"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "479c00cd1b76e61d736de022dcfca83325d786e429e34a06fc48a44e6ed3d41b"
    sha256 cellar: :any,                 arm64_sonoma:  "211e4bb3877f8f1f3dc0c47215a7d6b7e7586b767949ada68c773f2db8ed05eb"
    sha256 cellar: :any,                 arm64_ventura: "ccf420dfd89fd69293de1099daea4988474d7dbd7087e42d8a80d96ec78e1dea"
    sha256 cellar: :any,                 sonoma:        "c5aca4fe4066b10c0f468268bdaaa30daa1ed2563f38994b3ff3d532c0425b6c"
    sha256 cellar: :any,                 ventura:       "fbc0adf3a79405d7a8c44ad3b12c9bccce5bd0e022ddf0d003f836dfcf636d55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae38f8af571bd18d56a1e3ab7ea094464bb359fda9532d6279f2efe1f46e6b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87f72d03ae1e594fbce12b5ed8bde36d0bc0c71899ee211d27fd9f329152e26"
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