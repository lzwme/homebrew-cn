class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.77.0.tar.gz"
  sha256 "4f4dcf46209a96800715ff1178ca66f2dfc2c77018ccb23ebd27bab49d06d234"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2838b5d5daab2ce154708a951c6b7092e16c72d2f74d3cd19e9bc8ee031d913"
    sha256 cellar: :any,                 arm64_monterey: "0d8cefe23431eb0ff95e018cf362a411cede87218f3738ec96849a9102df2313"
    sha256 cellar: :any,                 arm64_big_sur:  "1626eb2a1ca15958a75ded647a7c23704631d4327c6c8b113922aa4dd92d5aad"
    sha256 cellar: :any,                 ventura:        "36f26951d1fcbe510009779d54f1b3e0c5d920fa5ada190179e325af173adb8d"
    sha256 cellar: :any,                 monterey:       "efa57260dcf8b526928e4fbf27f0e827c64394242b6e81ad969d606402431bd7"
    sha256 cellar: :any,                 big_sur:        "71d7609991f842f3b7c94b231185b66950049588907153bf4e6031c230917ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1083d19165ae3a111e2b2f827c8ad846871e2afca003223c381b33a63d6b088e"
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