class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.76.0.tar.gz"
  sha256 "d25de8ef3bcbdf9c5cdc6a1682651cd655c34703bab06d182939d5e0c3e80807"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76de4ec55f6a40e015fd08c3253cfe3b3ca8853b96038666430d71d7555fc75f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b0ae77734181fa2db8efae70210732960c558084c89f9055ba17dfe30907c94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7950eecf62b05beb657cbe12e09b4bf8bb7e54635b0218edd53e927d4f1bcdda"
    sha256 cellar: :any_skip_relocation, ventura:        "d5d4a8c98bcda848e1c318942d2cea04f2ce38b5c2700a89021024f9f85dbeb3"
    sha256 cellar: :any_skip_relocation, monterey:       "5ea665d031a882a2a917a08dc620bd8fae831edbb1e9e3aa2620ea710e6a278f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2ceb5bcdaba9fa716836cdcd3fa36d5f7853d387aa84701ba1b9f5081f55baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38382ec7ba4d45a62ee8fadb416e295641849edb7271e16cef76e3ebc769bdc4"
  end

  depends_on "rust" => :build

  conflicts_with cask: "visual-studio-code"

  def install
    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")
  end
end