class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.96.1.tar.gz"
  sha256 "95f93676e875a36538e5c224198d3dbf32a0fe88d10ae00ecdc1685bdbed26ba"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d0eac7f8a1f21d59e4d71d3c4019f2c9bffa812d33832f3f8f5b32793d050e59"
    sha256 cellar: :any,                 arm64_sonoma:  "5d3b38b686059759f643a3de3cd03cb6478231a96de27eb17cf885da558e3e3a"
    sha256 cellar: :any,                 arm64_ventura: "5ba9e8c4c569a743e7bd17fbc4f551e73ae9f610890d1734ae3d748716df2f74"
    sha256 cellar: :any,                 sonoma:        "815331a2b8f7da54721f8b10a7558ee82032293b13d071047a082f2d4ee6abc2"
    sha256 cellar: :any,                 ventura:       "9a3c3395c1b6b58804270b73d37d4cde448cde73020598dba6f9c8f07e822ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "245f09b6a92301dad3bdf60d625fbe74a1b6f17e7bb6ff20a29de31f13fa6b54"
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