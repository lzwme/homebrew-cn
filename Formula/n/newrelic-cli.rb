class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.96.2.tar.gz"
  sha256 "ab44d85568a1fafed80b4ef57c863d73f2eec20194d88915739fa00465411161"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b8faee307f99e9c73f8a3525303e859477daf5e42e308165f918bd9ebc501f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d805c389fcc466e6ee29be6dce341c0b1956a7a0212e02cc0a98ad6efd05fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35b511043acc89e4b4205205b9e0d02ee44578a0e2b5416068673d752099b263"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ea2a59f92190335c8c5abc4ebb94016c3497f6cd6a6ab721fd2f60a4555d1a5"
    sha256 cellar: :any_skip_relocation, ventura:       "239d76d71d11c2e86500cf6148eba894075b1e2e105c51496386eb810fb899ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ca4fa2e5bf4537431736f5454f295c0d2a203466c92b33acb94b60ce9f92c0"
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