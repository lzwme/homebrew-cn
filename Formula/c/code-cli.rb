class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.91.0.tar.gz"
  sha256 "b45bac7c4297e8bf502429950ccd5ee140b1b52f7d0c4386278318aa361e05ca"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b6a6ab92f7ab81cd183a0a45936d8e038f68b9915b43c3bf5f7afaaeb34769d3"
    sha256 cellar: :any,                 arm64_ventura:  "bece347c1f4e5435791a8a2d25810f92cb05358716bf92076b78f084a4d3a162"
    sha256 cellar: :any,                 arm64_monterey: "e767ef7595a990461020770456e843f194dcd02bc8ed01704cc9e42f07734980"
    sha256 cellar: :any,                 sonoma:         "2531d53c6cc47807c7d377a1eefe709e6c56f2c28fcb320d82234554b16e1430"
    sha256 cellar: :any,                 ventura:        "b932b4dcb20cf9fd948709d6eb20cdd1fc24e7d8fb9589346923548ee88e0477"
    sha256 cellar: :any,                 monterey:       "7ce240ed5d713c6e542544c24a5043c8b76261d511b56b0a27886ac85c62aa7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba0f74f47709ab4243275be1b4df78d9e70355cede13274abe53cd41374fa6c5"
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