class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.95.1.tar.gz"
  sha256 "89c280e9d84cdd41f0acec0b2cfc900bb46af5ef323c1f5f1073d506935f324e"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "682da4c36ab818f0eb35c1dca8c610a7e2fbd4ce8b6dd30c282c873701a21c9a"
    sha256 cellar: :any,                 arm64_sonoma:  "9077b0b0a7dd48cadb66b361007b44a720c06112a20c665f6f076f57a495509c"
    sha256 cellar: :any,                 arm64_ventura: "ba8e0f32cfc0d055d638c84dce287672a2f9aed679dd24e9d7a21e84cc24b292"
    sha256 cellar: :any,                 sonoma:        "71ae411249bb75e5279d2e787cacbd7abb892383da32799a3c7852b7c5e8601a"
    sha256 cellar: :any,                 ventura:       "b37553200432564f0686f57fc31626bde531a9ffa0b0596fd5ae7213a8279eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08de5f59074b5a89bb7801115cba0cab3c472cb6975488e02fa82bf4c105d133"
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