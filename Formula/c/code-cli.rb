class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.98.1.tar.gz"
  sha256 "bf4ebee3ff22b4a25393be862352e74ff2fed7fe23a93d409e865c0060037dea"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3ead9d19ae55fb16b8bfbc7f060b6fcb2514dca0385561d762b286ee69ecf1b"
    sha256 cellar: :any,                 arm64_sonoma:  "07ed1f102fb8c62cc7008be4d1b9c416edea657cac1f8db372c3612e468c44c4"
    sha256 cellar: :any,                 arm64_ventura: "2dab513bd9653819b643e3b067451f0a2c32b8ffbbcc32c4bccac44ed5396a18"
    sha256 cellar: :any,                 sonoma:        "8e6c93604caf071ed5b81f0ce71752336ad39f0f53877b21f3ba9daf880f03cb"
    sha256 cellar: :any,                 ventura:       "de13c6cafdd11e0dcdf6e2fcb1713455204b056106710ce09bf7b4dbc8e2c883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "656f1a947068053be1afca21ddf47bb3785b721ff6f9abf4ac5de5c26316ce93"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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

  test do
    require "utilslinkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end