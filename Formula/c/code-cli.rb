class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.95.2.tar.gz"
  sha256 "4fe770ade68c49e8450bdf033321b64676275824b24b4dcedca13646cb65b396"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d7c4a9bc37d4557a85b849a12f346b93bd6feb83713f19787b506ee2719bfc3"
    sha256 cellar: :any,                 arm64_sonoma:  "cc65fc244fbd1011074ee87b887eccde26536208e719c9dc98f02c7367c87a4b"
    sha256 cellar: :any,                 arm64_ventura: "f34966e6a81216710439115b9b8d4aae39efe03223c591db37ff5426181484d4"
    sha256 cellar: :any,                 sonoma:        "b3ac7a4db40327ab05abc2d07ba3267948bd1b6fa040c6bc05af86f9f83db1ca"
    sha256 cellar: :any,                 ventura:       "d24eb6ec4f8d50831b4dc653b677892bea0f1a55293a82b8d8ceb9d9b3a37dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035669d86d7ef03f6bb954cb46ed2ff65e86de34b064c2f37fe42e5c853409a2"
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