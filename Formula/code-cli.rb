class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.80.0.tar.gz"
  sha256 "92145abba63cd0e36876bf4c1f79ee208dca5bd272ecc31e976028feaea97c73"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c84b118f2f43c1dc2ba6c06c5e633f9a9f57e4f32ea3da323fe67658dcac419b"
    sha256 cellar: :any,                 arm64_monterey: "8f27f8fa206fb77d611002038dd57f63cf229baf38691457452e471fbf1df0fa"
    sha256 cellar: :any,                 arm64_big_sur:  "2b91e47362cce002241882f87596a1e33e9a0fe7eab2f7692273c085eb5c2916"
    sha256 cellar: :any,                 ventura:        "c82d1b8586efe06cd62c62c5a723e7a56ee199ecac22bf8b432d9849684967d9"
    sha256 cellar: :any,                 monterey:       "35b6b8c5e2d8c8d4d0446908e6aa7c42c1076f7472d4f4502706adda8ddf37b1"
    sha256 cellar: :any,                 big_sur:        "fe616d36bf00ac12f84fbb22839f2c0b7fdc62c5843897bb019bee66d75e8835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e6375b600d87706f0a67a6ba307b7267db8ce7f19af5853086fb7d370b0538"
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