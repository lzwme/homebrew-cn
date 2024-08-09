class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.92.1.tar.gz"
  sha256 "8fb80ebda6bdc8ee8851543df1daf5527cb7777eac3e4cc1e0b86a845f2947bf"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c61c0619c8daaaff7d25a7192b1e542b50d44e98c10002a8c98410450b0c3999"
    sha256 cellar: :any,                 arm64_ventura:  "efee683544ed6bbd49f0848beca8e224bf9d88008a63b791b50875277bbee96d"
    sha256 cellar: :any,                 arm64_monterey: "334e4b49a54cb874a377640f6946ffb23121703c901efcce3ce66c492aa88868"
    sha256 cellar: :any,                 sonoma:         "a9f8dae98dd4fb9fe367801dc22197efa72fac513381be5006109907f647a63a"
    sha256 cellar: :any,                 ventura:        "214526aba6eccdeb4f84d8004d21bd430327d33cb33c94077fbb3c072a16863a"
    sha256 cellar: :any,                 monterey:       "d8d097db45aebf8cd1d1cf1188a68fb280b994ec4ddf89b06e86f70384a525b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e578d5f68b31305ecd7ab051be18c3a67cd13bc7618b3975abdf4644c182e9"
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