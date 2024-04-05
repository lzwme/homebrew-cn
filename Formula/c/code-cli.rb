class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.88.0.tar.gz"
  sha256 "fd1c7d7c2bb21c3eaaaef530eeee9753c4b7c98c708d5306cdab57c9b35627a6"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "63d19ea185f917155c74abb1257184281c5e37b5afcf3c8182ff3c46be19d278"
    sha256 cellar: :any,                 arm64_ventura:  "eee1d9ab93faf2f59459ba6fa4d2bbc9e3dc84b2f05cb42cee8e64b088a4b6d3"
    sha256 cellar: :any,                 arm64_monterey: "8838a1b07c209227770feba084dfdb9677b12e7c832899254869f6f439e4c3c2"
    sha256 cellar: :any,                 sonoma:         "5c9458b587a1987874db75b3c988da98c347a3c626d1c47718df309223c35e10"
    sha256 cellar: :any,                 ventura:        "322da14d9dbdcfe19b2b5cc44ea279301184c1d7d0bcfb2bf64ea97cebeb1007"
    sha256 cellar: :any,                 monterey:       "e408e3b48435ad6e2fedf3b294cfdc61d7e0b8ee4885c658185bc208305ff4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9359c0d4e1f03adbff778adab712f665c2aa8d975ad40842d774e38136a09a4f"
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
    # https:crates.iocratesopenssl#manual-configuration
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
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert check_binary_linkage(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end