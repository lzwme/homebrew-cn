class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.118.1.tar.gz"
  sha256 "e2e7ef42496500a8a8687d29a7e78860c1857ae37c892d99578d342c1d023706"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87233d27a8d05bd165162d2568930581b3ce281a6ab2a351ab2a99dd68870bab"
    sha256 cellar: :any,                 arm64_sequoia: "b741be2149647beeb5a0f657f79484a25646becf4b3fcaee701ef8d1886c30b7"
    sha256 cellar: :any,                 arm64_sonoma:  "b43960aa47bd577a10a563088c72f92cd64de8f3d5658eae0ea55752b183979b"
    sha256 cellar: :any,                 sonoma:        "00bc5c4ea2b6c8bbbbbac5b59411fe54e8c9f060f23d24d7212664272db39d2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c24ec746e299d8c1b1d45f41d37e26c98e17ed9d0075dd498ff7afe053856bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b1849201253e1f1343ae9703e70385d2b605b074b298503d62b37b6569e0e36"
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