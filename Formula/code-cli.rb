class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.77.1.tar.gz"
  sha256 "f6f7223bb26c55b409918b5f89ff9ffa4f387aaebdb4c0014e42196c1a747b5f"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b39b699c717c1d65ff3ee8c3d0bcbb751380a0ffa3657233c5510374c268774d"
    sha256 cellar: :any,                 arm64_monterey: "16b8a19f947cbbfeaf8be46882ea921dc531c5a09004d6b714284382cdfbc73e"
    sha256 cellar: :any,                 arm64_big_sur:  "5a0110a46262fbc3a9d55080e7600a49a760f7be01030607b36db4c5cba395c5"
    sha256 cellar: :any,                 ventura:        "a86fc465cc620bf34064d689cec173fd07d6b7c7b88396c7bbc66344cde7f590"
    sha256 cellar: :any,                 monterey:       "5d19d5d09140ecd411e1490b6a989f1b651ff406c06de29946aebb16710c4eb5"
    sha256 cellar: :any,                 big_sur:        "80646c43e96962dc01e61c48c797201764732b50ef3fbeb21e681311426c699f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0effa1853c797486cad023782e5bb55b23fbb5ef629d3add64bce79d4f73e3df"
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