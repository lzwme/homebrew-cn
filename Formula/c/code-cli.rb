class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.85.2.tar.gz"
  sha256 "2ef53bc4f8fe97ae5f3c65036207d5bac3433793e8cca7c242b6245d940d48a9"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "946cafbb6b7d3278b8a9e271c1a81bf847956d33d0b1a673ce2ee7d996cc35d6"
    sha256 cellar: :any,                 arm64_ventura:  "0fbdd716fa0223cce85b78deb83d2547066fa54bfb8c5b5199c03c1d98a746f2"
    sha256 cellar: :any,                 arm64_monterey: "8cd8d100b70e39bbac752629a3b8e837bd216e4e5b4ed72074ccc1aa2032b782"
    sha256 cellar: :any,                 sonoma:         "1a0389909994810c64bed9ff4d06b970b118313fdd4c1848c5295d5c4bb961d8"
    sha256 cellar: :any,                 ventura:        "fc4dbd13f0e823b75d8ae2ca3f75bb93fa75ad56e33bb263379d631cfcad36c2"
    sha256 cellar: :any,                 monterey:       "01e1c766df638aa0f49c6e774a69c0b3ca4e27925ab1dc2704903a3ccd1b0303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11987037731756ee166bedab04cad73ad706e60920f30558e652e94b1bc9585d"
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
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end