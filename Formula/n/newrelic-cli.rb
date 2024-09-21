class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.94.0.tar.gz"
  sha256 "1115c160d67caa6ca1baef44bd456c2f0d01c0cd7467aab193d174c2a83f6200"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f250ecde71184d74fae68ff4b1e3be566ca271e3855dc10894ad05c71e667d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffa338fabeeb8184fe232f859a96607311d50d5a4adc437e9c77b3541ea771ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "751c3111c11d797acf3b4623e985c52d5d96d12f478ca35c4264576f9e6242d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a70a5b88bf58892d06e706f81330751352cf7c8ca7a6123f1ea4e873fcd73a5d"
    sha256 cellar: :any_skip_relocation, ventura:       "4c0ec79114c7e30585acbfec23ebebe7cd2f38b263b5d761972b9dddd4420876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e111f6636d675b4f265a9aaeec0d580fac6588d6bde700ef5df5788b8172f5d"
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