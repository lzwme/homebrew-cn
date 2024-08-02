class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.92.0.tar.gz"
  sha256 "fbef7aeb7101e3d52fb728cd004d2a7147e976a5f4bf806ca7a4901da03bfe92"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c711fac7a0ba906652c9912970f42f9d9b03b161ce8d1312d8037bf8aac73067"
    sha256 cellar: :any,                 arm64_ventura:  "cf8d70b9aaca51f4a1cb15d46f105ac1f5a4904ec235d4b40f1a9b785fc63c62"
    sha256 cellar: :any,                 arm64_monterey: "642455cd5cf58649ae611f951356a38a15e6640adc55ff1dc605e3ad02606946"
    sha256 cellar: :any,                 sonoma:         "a6ee03df233583a2af94cfe37d40e417eb955f49b13bca293eee1a37e5a919ee"
    sha256 cellar: :any,                 ventura:        "8f288ed62426d480e24044ef76fc02553f3c3a14754d1529f4d0250c8d391059"
    sha256 cellar: :any,                 monterey:       "f5a9753ca739838d8c86f1c0ee784ebfa728690521f3e50150e3448727d787ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c52a03a6a39b238f5e71f9e3b2cc6f284f4ff8cb563a46ae2cf5a3e94402962a"
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