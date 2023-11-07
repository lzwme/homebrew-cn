class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.84.1.tar.gz"
  sha256 "67f66a6bf9180912006abb54a943febb27833ee5a7888f70d3465e581988f74b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34445e5bb1a31b3f30e2bb6a162fc92b449b86c4cfb3da010f954d41547d4ebb"
    sha256 cellar: :any,                 arm64_ventura:  "4d68f46545c3c7c35ce35ed9b868f49d4b2d438fd4ccb364ff2183a59d04d30f"
    sha256 cellar: :any,                 arm64_monterey: "88ec9f093da41d8664dcef5445b23f662f1d7e9d662b12708465fb2c24b66046"
    sha256 cellar: :any,                 sonoma:         "dd8488e9b0635a2e578d0137e36f81a65b189b90dca0c6018be0775544d698a0"
    sha256 cellar: :any,                 ventura:        "7745a5a47de3c18f23a599d4857ab72b29a6a42f28fc78c2de733cb8747a4a64"
    sha256 cellar: :any,                 monterey:       "0ad0407753de6adee77489ba878fc2562a3758d5f8591a49dbc96e02c75fc9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3cd76d58799194cf81d303ed44edbbd2d752645e2b11a57f0066ff01acc536b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end