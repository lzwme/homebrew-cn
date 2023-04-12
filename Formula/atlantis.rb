class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghproxy.com/https://github.com/runatlantis/atlantis/archive/v0.23.4.tar.gz"
  sha256 "21e09333cef5dd1ad47b1ef20fff50689907e5777d428b4214f29d42cabfdc21"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f708af35b7c23928caae2776c1d12bafa1decae52ca475dcd067b6dc1787fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7f708af35b7c23928caae2776c1d12bafa1decae52ca475dcd067b6dc1787fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7f708af35b7c23928caae2776c1d12bafa1decae52ca475dcd067b6dc1787fc"
    sha256 cellar: :any_skip_relocation, ventura:        "00196c7cf23c25b4146aa48f5c5fe49e1b392b15280b77c829155a5b2881a45d"
    sha256 cellar: :any_skip_relocation, monterey:       "00196c7cf23c25b4146aa48f5c5fe49e1b392b15280b77c829155a5b2881a45d"
    sha256 cellar: :any_skip_relocation, big_sur:        "00196c7cf23c25b4146aa48f5c5fe49e1b392b15280b77c829155a5b2881a45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "943589a0f03d3899edfca1a2c5a88d79967dfb70292c1e75ec0daa8c2e0a2a4b"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end