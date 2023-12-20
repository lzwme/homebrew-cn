class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.0.tar.gz"
  sha256 "5d0b2cc177ca54ad0b867846ecee86c84514716135670d362fcc15a218d04b0c"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ce356412295133ecde12df427a61dbb9a967f99def5bc219b21f74842b3b901"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8706acbde003df09c9826847e45f2b16275c2104a165aeb0ee7034023929717e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8e746290cc99f695dad3ea1e46414b1db7e680869cfe516450145ea4b93815"
    sha256 cellar: :any_skip_relocation, sonoma:         "21e1e6c9e14469c3eb08b831cf83c16de19b6562899b1721bc6a3bfa12f77cd5"
    sha256 cellar: :any_skip_relocation, ventura:        "3203d10b28aaaee4010612b8cdc61da444341103746622da5741bf87c19483fe"
    sha256 cellar: :any_skip_relocation, monterey:       "2bedef884c4411ac0cb2e77d5cdd1afb9c1ce8e4a189009da93fe7cbbab8483d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1c6b8402c9b11b5f5c230ed1e94ecc1825c8debdc9c182bf9bd199366263ad6"
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