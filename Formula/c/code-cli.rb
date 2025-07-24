class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.102.2.tar.gz"
  sha256 "1f14a299aca4bb8016d16f4d50baf658ccfb8eafece1a3027e25154b4c5d37ed"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "75186679acde7cc502d40a2c17ef86724dc129566d91de3ccb07d64a160fe81f"
    sha256 cellar: :any,                 arm64_sonoma:  "002d0a78879b7880a0b4f86a05a4cf1158a1c670305010d4b8be97e4d8a1e83b"
    sha256 cellar: :any,                 arm64_ventura: "5c4aaa20438c3778062cc069ea61323b7cdf45e0844014ad770f99661266fd9e"
    sha256 cellar: :any,                 sonoma:        "2aadd835fcc63351e538bbef8ae2b8e326fca6dc1597fff98a382600b95c8a3b"
    sha256 cellar: :any,                 ventura:       "22e561e117133043b937f574dccddde685dde90c94fbeacf608a5225ce17a36c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16bbe8ca932a1d15eebc4a3d7abcc21a9f60aed62ba9456b51485422049ec5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caebd028e8f36ee7476e8ec6258652a21f05c4ddb9424d0f6f9189e6ed6c9a31"
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