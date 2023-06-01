class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.13.tar.gz"
  sha256 "77194f0af19d11eaa16def30a8eb611ea08dc8d0629f8a1b5ee6b91a00fe637a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60c05e9450616b50ad1a1e3bc83fd83b85b66432a6acf0ed4d78dc047042703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f4a226679082d61e0e05b3e6e8fc8fed90f3fe70cdb1baa7afb69206ae9f299"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38f9e4f869bf520bc504aec08ecfa9074727d5ae23492b574650d302ce77adc1"
    sha256 cellar: :any_skip_relocation, ventura:        "2de7c51eec28ecf6c638bec0eaa872183bcc48f3c5904794ec867c9aae3aa1c1"
    sha256 cellar: :any_skip_relocation, monterey:       "d69ffeba95c003b99e10d171001be3414f5cb8310d06159fa86c518bf4f8d0fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d0af1e6215f05afe0cebe8d3075e7d11c2a6f89ca42116fe5f14595b47927ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3ab738c47d5684c7ffdd61a151e5d8eb8d5ab4853beb3c7f986160cc451689"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end