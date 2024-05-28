class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.86.1.tar.gz"
  sha256 "0eccbe6072f9ecd6ac56474fc0ce62f24227b2900a8dc46fabf7c8bdeaac46ed"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55fc235f8f3d54cdda60406765eda2e8b231f0be4696e3a376ba096562bf8d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8eb63d318dd6ce45799b6152883cd02712707ee75220e6644fc85a632a3c9bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "582b55a69659533aad0edcc79d1b2a42f4cbdb9702b308d14a08bdaa04e208c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab07d42c4ee8cd235b54acfb68f535716579da424d5c47f76259d93ad93564e4"
    sha256 cellar: :any_skip_relocation, ventura:        "f9eff89374f5e02c6e114455223380110cec1d35db8ae0783c01de56c756929d"
    sha256 cellar: :any_skip_relocation, monterey:       "70d5d37ec878247bee59113df4568b66d247722178dd8728e8f79152e41d6ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63d8af501063fe63f1d2e40891581516963faf57535b69514670100887f002a"
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