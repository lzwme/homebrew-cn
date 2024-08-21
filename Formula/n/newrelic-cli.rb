class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.2.tar.gz"
  sha256 "b28d4143a366da6f4eab97e53cc754d01347d0822847de96a7600fc7f87c862a"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64fbdee3e9bf89d19b9dff428b9478bcf173a844f85c046da38438143bd03b3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4985426253f3305970730e415271e1cb79c9ee4bc52a1f8bada024949043a530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2417c457898477346e919777b0b2e4eb4e33ec0c3e982d7843539055ad247fe0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e273e07eb834820efa19ad7ca4ae411fd4c107d32ccbca09fd554cb7bf8d0bec"
    sha256 cellar: :any_skip_relocation, ventura:        "e5d834d6db9fe168e285b4171c3ed4f497a9d5a96ec06caa38bd1e3bdc773546"
    sha256 cellar: :any_skip_relocation, monterey:       "5e6d662c0471cee141bc545e98079a125fb41a6fc6c7b34d2cc33f69881406fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e88be5c8da1e842593a5eff4f97776c2aac67c0865c9efefb8adccdd942c34"
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