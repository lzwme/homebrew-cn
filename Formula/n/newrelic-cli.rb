class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.13.tar.gz"
  sha256 "c145df56cab8ed03d86714dc0dd8200b344f97b54ca1a6f72b64240593372892"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b5dc595966f84c4b654d3fc686905581b727eebd4fda574df284b3a7978c004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b856b9962cfdb85f5f5ac46afaedf8d2720a62d58512a5d9dfc7995f84f70e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0a0e5ba3cfc702c048e75c2fc2b6fab400881aa48f086a9d924b19106b1eeea"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de7368fb5b60d8a3be69820f740f530af4a8e6f2cb8d27804cd13f652894a78"
    sha256 cellar: :any_skip_relocation, ventura:       "b821cbc6f0703e0a09800d70025831fc6e5f986ba77d5ae20d266378d9768779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "575d77e055f49d531d436673c72fa1b7c41f45e97d324d20e28aa5652847c343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8200c7a9dce568d702a7a6dd73f5abf1530ed4ff8487f7ed763c5643869ed6ec"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end