class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.96.2.tar.gz"
  sha256 "0de50a01a2fea9236e1b0151deaba3cdcf9157dde7060a915490c21ed03c6847"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e710e5bafe4c7663d6ce6fe8954f599f9539914c8b97071d8003d5143fcb2db"
    sha256 cellar: :any,                 arm64_sonoma:  "8738f995b63b17b939d6ab41108980f73ee48ab8f6b54d1e143710ab3068d795"
    sha256 cellar: :any,                 arm64_ventura: "f22bff8b09d6be70601708519ca0f2196fc9ddeca5f603aa7ad86d394f624976"
    sha256 cellar: :any,                 sonoma:        "618db05f0ed8d8814a613b13a1754b97221684a41056aea0d5aae5de7fb39b25"
    sha256 cellar: :any,                 ventura:       "cb217c16fe576c322ed7f5d55e371c880a514c39fa80d1f8c22ff3690a0e8bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1fecd5da01ae8e611102f7ad9aff2dbe7d6b92556c8269584a0ae655df85f50"
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