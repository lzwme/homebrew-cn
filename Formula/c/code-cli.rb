class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.82.0.tar.gz"
  sha256 "bd4b50e7325a458d37fdb6bd1ed243611d5fa4676434c2f6ee91ee640b64d68a"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "79a0d6f307dc76c7b0d1def7b4cd9a54d0e3cbea9fed464c12483872ba76b847"
    sha256 cellar: :any,                 arm64_monterey: "8e0e140539cc41844a54fcfb7ae38adb49f7196f884fc1e075205fe96c5f3e40"
    sha256 cellar: :any,                 arm64_big_sur:  "09c8f51dd2e612cc7a0e43e3f727b83b8a0e36dd6613c0d31f63d30a05083772"
    sha256 cellar: :any,                 ventura:        "f6756e7b8a63c6ddf8b282af94d271ddd3709d83e7e0878d8e2a38e92428cb9c"
    sha256 cellar: :any,                 monterey:       "fd3a23de104d1202cd0fe2c35ab4db0d7eccfacd7000cd031f89898305a31137"
    sha256 cellar: :any,                 big_sur:        "9c29749f74ce4452a427961ddad871d288a3bee7f1b09880559a5255eb4e1ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da414ee04acdd80f4aca307d7e7d5fff82b2b53a86adc89b4812dbb4ad78c02c"
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