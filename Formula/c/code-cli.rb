class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://code.visualstudio.com"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.137.0.tar.gz"
  sha256 "bb9479618827a746f9daa65c2fc702e5b0a45bfb4047afa42ad376d89e7c2fd6"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c38b8996782058dcef8a80e0e3ec5e4d3e08244337fea3964c7e381418ecd389"
    sha256 cellar: :any, arm64_sequoia: "2c0b0d740158c318a0bb4f7b60fd15079cda9b7b42ba5cefc3ff4b06dd161a81"
    sha256 cellar: :any, arm64_sonoma:  "812fd2b0e9b6e33c1e44c8d5506fd576f8c0ca86481ec88931652ed65b35cf55"
    sha256 cellar: :any, arm64_linux:   "98ea2ae4fd895f21c586f502794c741db5900cb53cf8a701fe30ca4e82e5a46f"
    sha256 cellar: :any, x86_64_linux:  "8f47e3b68918c6d6464094e68610ed663c5ec759415e52d4da24a02ab7bbe164"
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