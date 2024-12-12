class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.96.0.tar.gz"
  sha256 "af97cd73fe7a0fa947c50346927b4c3707a9ed80ac76f4284090f6abd716987c"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d5da78f0ba75900e45ed7cbb3ae229a03de34b8f81930b146d43a0877a9ca39"
    sha256 cellar: :any,                 arm64_sonoma:  "d0760386c3501bafbb681e6abc92a8a0460310d711089b787f80612404490f20"
    sha256 cellar: :any,                 arm64_ventura: "51225ee1005d0a5824ff19755b340613542dae2cbe7aba0a5eee3bae9aad7ab1"
    sha256 cellar: :any,                 sonoma:        "68c346f5cfdfb8baf5b4c4ed401fbd199d0b609710580dd2b85e087b6b869578"
    sha256 cellar: :any,                 ventura:       "ca5b033ca6da480a146c462d6b9410f18d2b0a8c36e53cf7dd8401ff692acf02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9ee17fb34e7193c8a43eabbf82a63347a5a2bf42cfe18d3fdacbff2d8db58c9"
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