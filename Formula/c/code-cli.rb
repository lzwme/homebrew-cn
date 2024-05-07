class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.89.0.tar.gz"
  sha256 "624774ec364a6d65880192ff62f6d8c49087b2db90399790e4c64a61dd4fae18"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "18950b3303b337e6dc7214ef1d16c3a7e752501ec668ab10fb555842ddb3345c"
    sha256 cellar: :any,                 arm64_ventura:  "8e172e846d8771394cf9d35e3d08e16a2c91f9694f45584df91eb1054903a869"
    sha256 cellar: :any,                 arm64_monterey: "01d1827c50134fde90357c8da3060059f2aed2d4c214ec08d74481e616457055"
    sha256 cellar: :any,                 sonoma:         "b2100d86c81363fef10ed10d4ab01d64a8d8682bd2588cb0db1dc5c1aa5df0bc"
    sha256 cellar: :any,                 ventura:        "bdfa204b706a78a778c246f088c5178129a0379f2795fb43a41f4f2661fbe596"
    sha256 cellar: :any,                 monterey:       "b62fec3cf599127bc4018edafcaa0058c7572f35b5d43f4499cb359855b6bc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a787a974b53975b16efecf0274721a14d4b0163aad360389dbf5fa83bd6804"
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