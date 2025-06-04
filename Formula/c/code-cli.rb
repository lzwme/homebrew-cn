class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.100.3.tar.gz"
  sha256 "41aea581620e48f7ba33e29ab6a9b43d25632ce11d06480cdfe0e8f904fe3637"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef98f80fa1ad7658950330ea757b0f1f673b63aa5ee7e28a87f8ea4b5402b0fa"
    sha256 cellar: :any,                 arm64_sonoma:  "023a90fb6235faffd817090c3585801fb0c8b424c3e898a9407b72cb4aa5c495"
    sha256 cellar: :any,                 arm64_ventura: "a2f70ef780009a1466e0374258e124c7b0f33165e7739bc6b340c609aa9776f2"
    sha256 cellar: :any,                 sonoma:        "913ae669f30e3999eee3b096781c14987a7afdaadfa35d7efb37a1b835ac8aca"
    sha256 cellar: :any,                 ventura:       "ad00c9594e464d7a42099fb5f9c39d7fa8779f491b6b5ebcb63858a091a2ff22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b2daf76d31d43dff5a2a985f6942fa892c3307f75b50e2048d8ea4048e8555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3404bc73eda0de47b2ef205c8c9ccd46e53d944ca79d52bf3ce6fbcbeb1ff682"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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