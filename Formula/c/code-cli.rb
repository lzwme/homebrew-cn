class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.122.0.tar.gz"
  sha256 "67e293eec3c87207bd9fb2414cad9c684bbc7405ea3045e0c6a16e91f4ea8efb"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "519ee40823bb4a5ecbefa272afe0115e558f898dee95e80265999b6e82efa5ac"
    sha256 cellar: :any,                 arm64_sequoia: "00849303b9d8a2e92d3205439b8651988dc1c8f0cee83b723130447ba5622269"
    sha256 cellar: :any,                 arm64_sonoma:  "5f8c5ddfc155074f7edddaddaaea9d4703fb2b765f2f708463f2dcbd5826fd35"
    sha256 cellar: :any,                 sonoma:        "bd547e056481dc8e08dd257e839c775c2e358f2270831469b156ddd78ccf9786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9499ee633b04e656dc11db64cc602174588a4806f1477e9a0e339edcdec2076e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d570be71be8702e2e94b55b212158a3bde0b440ab2b050212d07f459cf7d2bb0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

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
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end