class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.94.0.tar.gz"
  sha256 "6653796e0c8a8e551c9e47439732ee42c966299f147c2ba8a23a8135756457af"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "763d2af418aa4610f354ec411cbeb65031f420273fdecea6468dcca11a1d12a7"
    sha256 cellar: :any,                 arm64_sonoma:  "729cefced9345a6a2e7300880b1e38a413f44aa9612b87e5382e44458c25e83d"
    sha256 cellar: :any,                 arm64_ventura: "6fa690ddd96101a6276b837db2ec7c2ee7a2f23335b3a3419f38349ea0577b6e"
    sha256 cellar: :any,                 sonoma:        "602a976169ab51092e4676ae601795bac43eb58ca65446e1ca7091b311843616"
    sha256 cellar: :any,                 ventura:       "21548211c091fe9b35f7f3ae152c27cda725e56c8800ead0a199f7453c726122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ad6fd7fb1b1c2a34db12ffd2a93c6fa1524d652a55de31f480c91c797e0893"
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