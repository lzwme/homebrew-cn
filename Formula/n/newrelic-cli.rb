class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.81.0.tar.gz"
  sha256 "3a6c5f52f5525717fe3b0352a299c416ab23789c404384f848442f6387cad48e"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54f014fbec0b60a3f5be9451bb7c98e89cc3f4aa5c82325271e0dd3ce0ed96ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa5f30979c2535582e63f59e96e3fa4ae0db8279f523de007458dd923ca58a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36dbe13e97753ed61901b68fc5b11509f63b576029bad6e0de4d8e025245a86"
    sha256 cellar: :any_skip_relocation, sonoma:         "028235b1c646807f4115c780d45c0c82627c1afd26ef2476859af2b9b7568df9"
    sha256 cellar: :any_skip_relocation, ventura:        "4efc860ed5d1835002b1abfcfbd0ad871f4502e233c518b7088372cc92d735e0"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7d06b4cf940f5f59abe4d8ad0bcac1512f1d723e8e3968d00a0fb7ae1e5d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7576ed334ce761e54ce316e4bf4a91827722316eafa86d4a75ba54d18dcac120"
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