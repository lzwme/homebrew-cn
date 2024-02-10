class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.6.tar.gz"
  sha256 "f8a002e4eb21fe8eb34f6b10bc97f8033c90d834a96b7597f2e3037c673a7b5e"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57e9d9b5b5d46e5162cccecdafb5608a0994fe81749e99c418cd54c58d0aaee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5aabe47ea3a054f414b0085aafc067b0c20c6b7b94c64f7a667444b95d7cb76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2830625d3f4d656975ddab659746ee9b7e28c482c36ffb45806164216b160a23"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd6559ece861629e22695587a3a1050229c150f431a86d2cb5ad4d8a08eb6031"
    sha256 cellar: :any_skip_relocation, ventura:        "8263036901c9df9a709e369e367e8d9897b470ce6111eeae6619c781269d6760"
    sha256 cellar: :any_skip_relocation, monterey:       "3ae7a8492800a7ff19978d56c5de95ae317ae79297d6e402c549ecf079ba6f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ec674c3adac7051bd997d9637d9c9073ee6c318a57500c819efdc914816599"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end