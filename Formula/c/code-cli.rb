class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https:github.commicrosoftvscode"
  url "https:github.commicrosoftvscodearchiverefstags1.100.0.tar.gz"
  sha256 "b47bb68595466c9182fa5cdcc1d3298486e5f914fd9892cd11ce1a5eb254cea7"
  license "MIT"
  head "https:github.commicrosoftvscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "355728f3d3379f1534014b67e1ba47ab496ace391dff6c65020892fc86c78094"
    sha256 cellar: :any,                 arm64_sonoma:  "cbbed511508b65c761cfc12528799b009b5def747f4944a2dfc317fbe7fa18ec"
    sha256 cellar: :any,                 arm64_ventura: "bc0416e85118eb7b717a32e6a5ecc77aae41a437f5ec6a8c8dccc92b271c4237"
    sha256 cellar: :any,                 sonoma:        "a961e0e1a5be991520bd04cc415c4fa143f306637f070a8175203897567312f0"
    sha256 cellar: :any,                 ventura:       "7ec64ccc1057679b9fe6f6f6f67da7d93dffe61baf27e499ac28595593ad7db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a75053b6d3e4f9e9a91a9bb5289222c0433231465d40d5b4a2ffdd16ada7a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1293e84cfc4b199a3972ebab27f3ef70e21c19b69b9050218ab46c42e0a97d"
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