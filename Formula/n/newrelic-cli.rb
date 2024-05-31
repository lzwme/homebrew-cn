class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.86.2.tar.gz"
  sha256 "a6c55d62709e0033e696d4e897a5bc82ea9b654aa59e018d1cedf9befc0e42cf"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b266e1c147cb1da5cb5c77bb1117fda9db54ee517cca5c4b2bd608d9457872a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3da6a7049045cf9a0cf35f1ff35629e67debed47a596ad725637db427729bbcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e3a8b8bb54c69f0a2d945965c7779ca95dd874948eb8ddee359144b909aaa89"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ae4acf44e3baf11100d0e8b74502174639d1f979d036cb104a689700c853358"
    sha256 cellar: :any_skip_relocation, ventura:        "027df555d3a4c7799092ecee916c3c56124facb649ab16619345b2f87c6695b7"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e83cd936199f1beafa2a0e823aec9b7ad22255f4e4b64719b628d82376ed5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159afb791ff320ff73f3e44b1edbb3b5574aaac5738ce5b40b55da5331e7bc52"
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