class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.90.2.tar.gz"
  sha256 "e0d398ed7acdc41af5e458782def63768f1ac1e7b14e4ba304143b405fd60a06"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88ce77f1d2d6c0e01c75dbf9d930d595cdbc4ff3eb86c3172b0fa90c8e073a19"
    sha256 cellar: :any,                 arm64_ventura:  "58b572da95f0fc4f0522dc7f608df6369eacb37d5e6b405fabc596ae45bf596c"
    sha256 cellar: :any,                 arm64_monterey: "6a8cc93baa050201482ff95421d5c1ab387880e450a1de375be6d31cbaedfc71"
    sha256 cellar: :any,                 sonoma:         "f7dc07aa1f7d76f36dc94434339166c14f6a3bbaa82bb348643e361bd2dd826b"
    sha256 cellar: :any,                 ventura:        "1ad2259fbaa8ac7a376d851889c81fb9861b38922f8d8c8bce82870e0dd9b7b6"
    sha256 cellar: :any,                 monterey:       "70c96d2367b529e3148319717e32fe729af5888fdab1079780408adaaca2d5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e835e51fdc9e345dd0024b107fa36fcb4db64d2e430f775b70f17f3e035394da"
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