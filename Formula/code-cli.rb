class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://ghproxy.com/https://github.com/microsoft/vscode/archive/refs/tags/1.75.1.tar.gz"
  sha256 "97500f244eacd66556c2bcf2d9a63b2509e363f9bc8d587c6fc2feb6bb1a5e31"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "472fa6f1ba98f68d4a5b68c4d8f18ce94946af697f524e3c11bb2372b364326c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d57fd1ecfc6904f2d589f8a7b99216be0dc6d90fc552a689ce823cba33f50c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d20c72d8c16adbeeed693e6c74baed455d467d592b696a7cb56ac404fdb5820d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8d45983592c154b8df72e815cb4bc59c9390070a05181f5f444c71f98708a71"
    sha256 cellar: :any_skip_relocation, monterey:       "c18539d2e1639dc8d3ff09e8a3b4be35de32588b3b6974191eb20ee3d95af473"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c29ecad107706f0af44011887d1617bc8daa381c224158598206fc830a2530b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d731dfcd5e02e828d4ab28a1704f18a0456e6d1399d76eb8032a0ab6ea981ebc"
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