class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.103.0.tar.gz"
  sha256 "1850417b24dd935e2e9423e1709834660e7c995c84d6a6e818bd1c102208623b"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3cb6f2f03a7bdea5f1f95b1e2607e6fa21d61c420c15de5dc83199623aa2464"
    sha256 cellar: :any,                 arm64_sonoma:  "dd8fecea27ca4ed09ec0c05f0cc6b2ff2102a1187fc34c7129e611a3c8ff3a28"
    sha256 cellar: :any,                 arm64_ventura: "2a815f47a3fedbbb4cebf1e30a525bebff7ea6165dd52377514af7cda203ee55"
    sha256 cellar: :any,                 sonoma:        "1454602029553380358c80ef45638108aac65b0aabc39f3404310021ecf203fe"
    sha256 cellar: :any,                 ventura:       "479fd062a8695aeee39e20e59cb7eee6f369632e08fff186eb7183459d00952c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dccdf4edb9703dc37ba57785ce3024227db523d231aff387df6dfe0fd84b782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ae78edb39398c1de5c78e53dcf22073e97c9a2527fea7fd8c734155f9fed00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end