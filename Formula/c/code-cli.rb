class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.97.1.tar.gz"
  sha256 "01073cec2ad504a40006a16821a7bace9c9ff725c4c3ed0643beaabbb207f401"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8e77ac438faa94d01c782fe44a3d4a0b8563d33671bca7ce103ceed2c9519d5"
    sha256 cellar: :any,                 arm64_sonoma:  "dd732e4dd0ed6dac7b54e7469b960d8a2f78acf2ead49ba53a9fcc7ff0bbd443"
    sha256 cellar: :any,                 arm64_ventura: "b79f28668db5f98947606ee3f8ac8ae2cf87c1e91c03a5cedf945f2a466edbd2"
    sha256 cellar: :any,                 sonoma:        "0e5b93af16242b811ac24633ead9ca75bf736b09cbd3c804cd61402692139178"
    sha256 cellar: :any,                 ventura:       "dfd1a71f2b39b5f4cedd7e07d514dc1f10e73a2dfa5d7ead6c90ef7b6f2cd166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e85799f5754f0960de8ee47b04cf59f8a0d2d508df354a605e5fe48310d167a2"
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