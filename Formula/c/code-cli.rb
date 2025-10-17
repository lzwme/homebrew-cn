class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.105.1.tar.gz"
  sha256 "eb070c42959c35f59a46659dcb5570e34b11454441c2199a459f8b125e6f907d"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68640451c3629394dfa92e41b908d955a497d5162e25b61a95dceb47aa966102"
    sha256 cellar: :any,                 arm64_sequoia: "1b79b7dc68b73991bb5fd9932a680b87dbfcf3557dbd4390ffea177996c2cad9"
    sha256 cellar: :any,                 arm64_sonoma:  "a5a981b80434b15c7ffc22f443cb801ee92ad1e16b60f71f9dec265c4f0a4df3"
    sha256 cellar: :any,                 sonoma:        "f4b3cad4a15cd81d9ac66ec96ebad2cac4d33abe04452e04541379ac4ee76b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6ff58c7bebf33a8b9811d90afed4ba8bdfef910a2c171fbde018910d4a3380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb850210d7aa1c3d4470ebd7fbf55c204b9b8f36a00b086ca2086bdf25c507a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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