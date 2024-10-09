class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.94.1.tar.gz"
  sha256 "ae41dfe9454fad56586a155bbb289011ba0fdb2fc37131748d3291ce5c588c4d"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70724d38d1b167393f06ad758d8429b3f26e7d52804ee32152357f6596ac30d4"
    sha256 cellar: :any,                 arm64_sonoma:  "57025cb50ae5f6d210020f1ddbd31702ac6fdbe1a9d0147e6ee395d01e3d349e"
    sha256 cellar: :any,                 arm64_ventura: "4251fed668bdc3a4e8d03c769e54cbd90fa6499acb405b4ed5fca26f124202ee"
    sha256 cellar: :any,                 sonoma:        "823d059443113a32c1c910e26bc2e11e423fcaf3c01b4bb5ff456ed0e2f1043c"
    sha256 cellar: :any,                 ventura:       "feb92084dbffc2aa468c793cc73e47f7018ed1f9625255b46b7d391c9416e2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6149325bf6f35ed6225b70455caf787c55be87b5e981a7836d4d1fd5528509b"
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