class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.93.1.tar.gz"
  sha256 "e9260639ebd160a6a6435cf53178bb2bc182f6abc5480db16ebb05f1f52980f9"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "221984a3b8226f63e3b6679f5adfdff167f5e146f2bf6516144f76125019f830"
    sha256 cellar: :any,                 arm64_sonoma:   "f31b08549d7ef7510ab3977fa02fcbc816247185153015f26c88ce2791b2bd92"
    sha256 cellar: :any,                 arm64_ventura:  "ddc28e815e2439feefe2e349d0c69377a249f1699267e31ea93a33d9e3d5b39c"
    sha256 cellar: :any,                 arm64_monterey: "e1847f0104293f57bdab1321959d506873885b380f166ca01363d44ac232518a"
    sha256 cellar: :any,                 sonoma:         "1e01f21c4d255259f0f34881d11dc0c2c751ccd72aa046bc273c2de7fdba67f3"
    sha256 cellar: :any,                 ventura:        "e095230f32694e86a8a19bfbf1d748ba610cefd0b0dc6c49fb4ae67a659a70d8"
    sha256 cellar: :any,                 monterey:       "cb52522b43af56fc3bfb6ad91a22d67cf5e7daf4befca0ff6847762381f612ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7dbcd756311d50e9b48fa5eb96e88bbdabd7bdce0e0ea943eb01cd670c27c66"
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