class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.87.1.tar.gz"
  sha256 "847d2fb7830ccd835fa365504b7c8bd5a416d7d7c1e85e511519757f260bed1e"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1db9b8885e066166f0fed3e4b468f84d8e7f6304b1d44bb38cd30385f61eb318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c842132b77ccc51cacab37da465b96392cdc7d16d906218fdc2b31db29c5810"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf2f9a506e7760dda5c4993795b7ee7946a2fce5395b593465ce73cf5a12a536"
    sha256 cellar: :any_skip_relocation, sonoma:         "15fc0d331d048eaff31c84ae599ba812c513069fa1ccb85d1ec7a4f0ac9d7538"
    sha256 cellar: :any_skip_relocation, ventura:        "ff40a06856369857c7fc4523a701e825da6be4e519124670bdaa0f9c9555ecaf"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c0c86abe95f2220873657fe04310ebf7aa61481199add80371b2196b5befd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b3c6c1c796752facd0511caf9ff14730ab938292ba74fa3b6e66d1de8d9477"
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