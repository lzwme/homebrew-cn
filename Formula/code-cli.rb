class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.77.2.tar.gz"
  sha256 "52e11c917113492e456ef70d96d63af0e767649e5536c2eb9167143fb25e369e"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6522cdf5eb424b0cd7cd6c8467c886ab1124360ee6fd677d5e71e21db419b74"
    sha256 cellar: :any,                 arm64_monterey: "acf18f43339909fa1518d04e5e49f0d37aea04eacc1fd568f1b09e0a5ef64823"
    sha256 cellar: :any,                 arm64_big_sur:  "d737989a8349dbdc38a76bb33648b3ce62d4be421eb7505623bb06dcc53b323f"
    sha256 cellar: :any,                 ventura:        "4edf47105903e772715fe331e8245b079f19cc70d988d921038b4f7f48f82b9e"
    sha256 cellar: :any,                 monterey:       "64b17d06411c7917980d694179250e76cfd2268d56cb90c69872044a1996349b"
    sha256 cellar: :any,                 big_sur:        "35bb62ce901816687a59a66cac7bf92fde5152c0dd76e096c02aeb0f1e57fe21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb83e48a9c3c6b5dbdab19f30452084632ef2b6ddaae6b3b178578027cd91e1"
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