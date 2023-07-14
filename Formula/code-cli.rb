class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.80.1.tar.gz"
  sha256 "54f3a14fa31b73aac84ff3c80d8d4237a90bc2c26822e463a17c3762901d386f"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac88ba1a41586937856393d75087994e8161623fb99f683c000b58bc2b74c3b0"
    sha256 cellar: :any,                 arm64_monterey: "3dd7bd700d5e4617ff77eb22f8b3a340713289b7c52cbc0529e0fbb9060b02ee"
    sha256 cellar: :any,                 arm64_big_sur:  "1c4485ea0a146b73b487b446a9dec6a0ef0f6137d58cf14228579ef7848fd9d4"
    sha256 cellar: :any,                 ventura:        "09d95f7eec8a136cdfa66addd4bb03eeb3e866e527b23d5796b42b8f5a87273b"
    sha256 cellar: :any,                 monterey:       "52fca97d2b8a8364c2f006984ce39871f05c45ec37171c25ca8d421614302313"
    sha256 cellar: :any,                 big_sur:        "e81a414fb00ad8e848572ee049b60a12e790d7b74a9c2c824788ee601f7e9c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aeca941464f8d41a0b12a2d4a8fa518c07173e18bcbb9bd78248a7919397c61"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

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