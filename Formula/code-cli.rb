class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.78.0.tar.gz"
  sha256 "7ce0a9ae87c1cb3450d758f2838f53825c471bc8a536e94968b442da0e2f7634"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9f363e51edddf0a385f17c05883f5a91673f9d9b0a48eed1fd5e588cb98104f"
    sha256 cellar: :any,                 arm64_monterey: "2d0623dd05282b43109bccc0ef2e708b24602e5d9081616a5f298d217500028d"
    sha256 cellar: :any,                 arm64_big_sur:  "d67e2924f38f71ed1e18d3d5831deea66c844700ecd194cd633f103c207869d8"
    sha256 cellar: :any,                 ventura:        "6ca9d9b7986b70042a2b4b7a930cea51e7d56c66447116e5a873952afcba18a5"
    sha256 cellar: :any,                 monterey:       "302683c8d59b55e1e515ad3c3ff26391cb3c18e42d99ca940ab853b269a050d6"
    sha256 cellar: :any,                 big_sur:        "e1c812d3612fcb7383971775212eba19c7ce04234e31d4c7eca5eae999f45c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6903374398ac2002c0dfeb55fe8c95c2fe6353459d5a65662c377309d2d3e0df"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end