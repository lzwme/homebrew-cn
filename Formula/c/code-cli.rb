class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.96.3.tar.gz"
  sha256 "4924100d83953adb819d17ed4788b974386550ef7f219d9ec2ee28d1f1cead9c"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e52d9255fa6d7e795e23135c0989bd87cfe2468fe0442a93a1372e8d899813e5"
    sha256 cellar: :any,                 arm64_sonoma:  "b0e90ff0bff2b80b9177ee09083818787918cf1aada337841fdc65aa634bb4d8"
    sha256 cellar: :any,                 arm64_ventura: "c7ce74f4f972c3e3106e2f6098d228cf3632a7c0c052fb74dc7a7e4a8163a0f4"
    sha256 cellar: :any,                 sonoma:        "cb756ace3fb6dec5e925051cbcf30fc63cda726c9c5d6e6d956c2d6c1e0c0370"
    sha256 cellar: :any,                 ventura:       "197590a6cd564f46c25c55337ffcbe304b7e63a84c2a1ba97119eae7503f2c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead11ca377f8045059db583afefc25f0469d430e56bbe021a78f0df39b9059d7"
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