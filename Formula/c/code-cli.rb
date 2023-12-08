class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.85.0.tar.gz"
  sha256 "b7fcf4fce5ce31669e93240783ff9ecfbe6d239bb2446c5eb3c11900d430a727"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1985f698445082f4f734261194402e0dc18a0d8be310259b8f1cfe4cdd690c1"
    sha256 cellar: :any,                 arm64_ventura:  "0446881a819a128a48a3a5fe6569fb71db721bbe2be0b009f739826960164568"
    sha256 cellar: :any,                 arm64_monterey: "6e2dac184b82e252ab9264f3693061492aa5aef7ab847ba5dcc802303f22e3cd"
    sha256 cellar: :any,                 sonoma:         "2a60f46691a5501f126c688c2cb302c48e68bade40d6338deafaf23990766b86"
    sha256 cellar: :any,                 ventura:        "142e71d849d2e40a30d83fc62c3e6b6fba18d3faead1461d8f7210c1cf7edb81"
    sha256 cellar: :any,                 monterey:       "30669dd95580f4df4216d27c935c4f5c1411aae8a1a06cc347c87fefd3c833aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5ce04a476ac2c99ab1695db499ea8b22e5cac00d4f4a812b1bdf1aa0ba5e10"
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