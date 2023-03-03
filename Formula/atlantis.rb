class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghproxy.com/https://github.com/runatlantis/atlantis/archive/v0.23.1.tar.gz"
  sha256 "25f66f79026a23b1fc7f7e5ce49e1b79f90fc0993d0b71df42cdffe7f92c11f5"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee012fc2eb2f147cd8575bba45fcc2f142f22fa2205b1f4eae22f006125b83f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bee012fc2eb2f147cd8575bba45fcc2f142f22fa2205b1f4eae22f006125b83f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bee012fc2eb2f147cd8575bba45fcc2f142f22fa2205b1f4eae22f006125b83f"
    sha256 cellar: :any_skip_relocation, ventura:        "29c2d6e78784d74751a17a630af895717fcccba057aceb6e78b38bd7e2a25f95"
    sha256 cellar: :any_skip_relocation, monterey:       "29c2d6e78784d74751a17a630af895717fcccba057aceb6e78b38bd7e2a25f95"
    sha256 cellar: :any_skip_relocation, big_sur:        "29c2d6e78784d74751a17a630af895717fcccba057aceb6e78b38bd7e2a25f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e2dd279b04650e1217b3080b9e3c1075781469891913bac21a5da1fd3cc229"
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