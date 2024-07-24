class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.90.0.tar.gz"
  sha256 "b7b92009cde7959342181278b41a55f002586bb1a3de05dea701a18316c2874c"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6352a3953e03cecc458495cf631024ca7d10fc2d4cb8a9b8ec8ec266003cd50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e880c630b46f793a5b411238e6831c327bf63789dc556c497002819d4ffb92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30757e7b723875baec7bf98036d40967f0fa6ba0d63e65ee9b0fc5218474dec"
    sha256 cellar: :any_skip_relocation, sonoma:         "1216a05c551151994a805ab4801df6ddd866cd9f56fe59a6c16c245cd2148df6"
    sha256 cellar: :any_skip_relocation, ventura:        "e00359ea7a99371cb6a47cc4d9cc9c2c9f0e8a6ed174a48ffac0d8ac8bb9d680"
    sha256 cellar: :any_skip_relocation, monterey:       "2fdc80d107cedb5ddfa579be6372a36eb2e2d9423d55885eeb9f37c3eda30a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3bae98986ae14228f224b5807004d075d4fd729ff680bb934fdf491fcbccd7"
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