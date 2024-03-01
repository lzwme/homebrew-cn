class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.15.tar.gz"
  sha256 "46f9707075055cac2f88ceda1fc2fec7298d3b7385d3e6f0ca7af410fd32d082"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6c639c61d7ce9cdda57a3bb0255d05fbcec02b5c6d87e90b7fe7f5240368a99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "148d5efc2e3cc447eba46a0a43cba816adedfcb4feb966594364e9a4017fe141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7d96720437f05b498bbaf8a52641a7df11e640e313d08386bec9bdb37fdb364"
    sha256 cellar: :any_skip_relocation, sonoma:         "055b33fcc1cc9cc6fe381bccee2f676574f9c2cdd403686b520f76fa604d5010"
    sha256 cellar: :any_skip_relocation, ventura:        "e2a80b0e7077734af34bcd6c981b6c9ccb226da1ac5b0dcb4b66df452a2eced3"
    sha256 cellar: :any_skip_relocation, monterey:       "031b8ba2d59c2a21a01c3825fc6ed2231aebd854236e2b9e2265622198e9da21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d108d075f1e0f05ccf7e58376ad5dfa6618b4e2e4dc0cdc23a5e5450a2a90498"
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