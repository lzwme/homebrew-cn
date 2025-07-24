class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.100.5.tar.gz"
  sha256 "2172c6f9de8db3c534283fe6f619d04cd15bc31aee6c58235f6f6fb510bbff5d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c65490b9fe2589f613d9c109d43cf5694d1f937a4120b3dd07ba35245d643bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1cbae732fbca60bc82c8151e5606bcc871c78074338dba01ffc45e4599a097f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abc1d01bf3bfae44aa9d803f98ffe2b3566c95a4b7b4d785f0195574055ed4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1af19c0d00dfc05cb1898fa9bd686e5ef113eebf9150f07aed65bf67283e6fd"
    sha256 cellar: :any_skip_relocation, ventura:       "97d7cb87b74c9a21a989eec40e6dece2c0d5860969e1b6276e8468f2da76dfd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfa059adbccfeab817840b3bb6f22362927d03e63b93f559725a37efe1e0eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a884e31d33fdca9dc369ea1994ceb5897cb2583d9f93f00eff92f3bfa21dc694"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end