class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.107.0.tar.gz"
  sha256 "8363bf4cf36e7f9ecfa9d24a0a1cdf3e7c2b06c0b1df5bf8d0e247eee51a4229"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e5c4be7e46a99333b1a52c2a47773c147211b5ce0965a44cc6936b67f4298d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18719381c48d127af5896ecf1fe9980edd90ee9610461b8d37373fbb284ae9fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ddcf44e9b17cbf1376e1f390e425208f92d89231ed5df1a9dea6d646014e8f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e63f455df7bf369996b7321e1462dfbb9aa61b3e7c1a8cf1b4d9c0b835649f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dae4533f3341a9526d4d06dabe311745807ca2532390275f76289ed628f84ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0981af21ef9a8d618cf425a375c0fe7c4b689f29ed20a2949caa9f7ec7467f50"
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