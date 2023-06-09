class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.79.0.tar.gz"
  sha256 "37a5182d77fbe670be180d1e19907ef5a0b970afda0ba57626a1d2c3d715ce28"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae1b53d92e9269beaceff9bbc1ddf7486c8d9402e4eef3512cce241543bef5b7"
    sha256 cellar: :any,                 arm64_monterey: "5bd04eff5a486fd441b6ed43e28237196988ef868240765d49e4c45731a5d6bf"
    sha256 cellar: :any,                 arm64_big_sur:  "4ccc11b71471c315a415961986f77cbcbe059cb6d206842839b6735f3ac3c17d"
    sha256 cellar: :any,                 ventura:        "9e5478c98d22d2ce1196e9e7a8951d43ae82b7bbf58c5422750ac5d133817863"
    sha256 cellar: :any,                 monterey:       "5125e96b61b0f985bf26f0b18702e58f716cb6a516286cdc05e4d72b710f46ec"
    sha256 cellar: :any,                 big_sur:        "1e85ca0077ee47b823e1760c2a06515c0505383917cc79338e4c06340bf6f6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feddb994888dc02866fb2c851b5eeaccdaf327d73dc97d081b2b63b67e42d2b4"
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