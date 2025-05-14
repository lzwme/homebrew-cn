class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.100.1.tar.gz"
  sha256 "628afc21dacd066eccaae5ce1ee71b6b552f035703d825e26aa78528925c4f15"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "830fed57abed8a8dbe2b353f3cd673d58ceba17e77434576cab5f680ad064b92"
    sha256 cellar: :any,                 arm64_sonoma:  "9f91c9da76ec67ffe29e039cd0efc496ac5ed13edd5a6f2e083d29106049989d"
    sha256 cellar: :any,                 arm64_ventura: "928f1125da46c3f3b76126e3fb9184605feb9f461975f01f8649c907d686c467"
    sha256 cellar: :any,                 sonoma:        "96dda0be2a0b234be4a4a51dcbaf39b1311d4fdc7678862e72746eb1beab170a"
    sha256 cellar: :any,                 ventura:       "6742d8b09388df1ebd02b87e3a41376083a9256496588b99adb2a3549553c687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ef659e84605e21504eba8b1a8914336b4a6dc721e79609783f99a168506be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3efd6261e86f2c741bb835d0544845625a881fcd23cbc9a66cdfb9be739d0106"
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

  test do
    require "utilslinkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end