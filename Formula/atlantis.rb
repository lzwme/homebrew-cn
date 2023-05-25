class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghproxy.com/https://github.com/runatlantis/atlantis/archive/v0.24.1.tar.gz"
  sha256 "63c81f6872a6c3a257d9260119cc56776b88c7f0361e4d5ab0e10237bed774e6"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379c9d64f0d8471c509a75ad78114f7373ec73228f95b42142dc487a6a0334b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "379c9d64f0d8471c509a75ad78114f7373ec73228f95b42142dc487a6a0334b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "379c9d64f0d8471c509a75ad78114f7373ec73228f95b42142dc487a6a0334b7"
    sha256 cellar: :any_skip_relocation, ventura:        "8c497b4ed9b27c66909cd3937adcd833d85f50d6f64073485d4a92cbf1d00279"
    sha256 cellar: :any_skip_relocation, monterey:       "8c497b4ed9b27c66909cd3937adcd833d85f50d6f64073485d4a92cbf1d00279"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c497b4ed9b27c66909cd3937adcd833d85f50d6f64073485d4a92cbf1d00279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d96a72efc852f3a690142b185293422040d6c5f952cc419cb77ade2aa1dec2"
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