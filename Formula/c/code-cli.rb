class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghfast.top/https://github.com/microsoft/vscode/archive/refs/tags/1.114.0.tar.gz"
  sha256 "3a57de4b3f4c8e0947a5bae1f92ba3365dca5b14b853f891276321c33ba34b95"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8acbe4b7e8c39580b3eac04332f321ec9d23afdcbbb95141b5b3e41a5a37ef7b"
    sha256 cellar: :any,                 arm64_sequoia: "529a8b39dfeea1f7267688c86f778c9133d1a630e90770d473f09bc9f85277c1"
    sha256 cellar: :any,                 arm64_sonoma:  "ceaafbf1b73bd8f8ea7a189225a7e57cadb7d1b5a5ccb874141d00f4748bce52"
    sha256 cellar: :any,                 sonoma:        "f36d575612376076df9e7bc99147561a1af1d74e2d6263333d9ec1a45e260f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7ede49545990a59570e1271797a7b110a1ea352653a3933ea596956f0c76205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6539852b76d62ddce9fecac3cab8c0cab9fe0f9fd3b37eb900101e4218b866f8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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