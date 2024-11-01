class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.96.3.tar.gz"
  sha256 "149aa40ab6da7b662d3462d7fcf3693f19c1f28a3d3fb57b09adb1cb4a4d7c9a"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ecbb1bf4418b57c10de86f62fa5d7f8a8a8572b40866f9cd538d1d1fd6ddd14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c79cae06490e6f271eee4d90439c5ead1fd8b39b9e2eb001929caae4b0391535"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bb989d75d9ceb793589cf448eed5d48b546276edc020759781c854fbf4d69cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7566c8dcf737ce706003a731c684d813d9a01a8a2bce3f81336eef922d67076"
    sha256 cellar: :any_skip_relocation, ventura:       "dc4cc2b6193c7bddedda625d9ab875453f2f4b8b0996641430482992cf981527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da37e6c3635093f4360fc2bab487653747a4166d6e3493ddcc105ac1e2c064d9"
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