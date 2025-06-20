class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.101.1.tar.gz"
  sha256 "fc015daead5b5a14422944af9b04eb241c78d5b7273888c46bb184d6651a7a2b"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3b3a6b8bd9eadcd06bd864ad83598c5751835334e4f1f3d83d05b947edd08da"
    sha256 cellar: :any,                 arm64_sonoma:  "bfe4256581e80583d7515cc7a4a6be173392cc470b663340d3754dc9ec143948"
    sha256 cellar: :any,                 arm64_ventura: "a7f8aa0806768c94ecd676afd7539b001788546300e40072767d15f7934384be"
    sha256 cellar: :any,                 sonoma:        "9e4ca03565aa6a401507dc2ea728c2279c8fc7e92ea06fbeb18aea53e3190c1f"
    sha256 cellar: :any,                 ventura:       "24316f30471fb179c1cc9975a28c1fab5cbf5512b58c5584a322d774d2baa85c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5fff0aa6cc4dd75df90a6dac668a506fe3c144f8bfedc3335426a0fd49f4f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f2b19191aed49e73eb206ca434b4fec50bd274200117c985bacc717f7c6b20"
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