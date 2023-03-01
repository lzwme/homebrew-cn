class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghproxy.com/https://github.com/runatlantis/atlantis/archive/v0.22.3.tar.gz"
  sha256 "28bcf3cfefafa31927866e7d56e307851712d7876f6df68bc5c87c4ae22bc885"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85e284d53594aef49f79126f3a03ae2521a526598a5b637b6de86878a411a9b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3807da98c1c1b91e2fee168146716f4b41c96a64ec3e3c6880460ae55194f98a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa2a2aca8320647fd9d313a9b6ea46f4e8aac2e12b463929d76dadcd1fb3226a"
    sha256 cellar: :any_skip_relocation, ventura:        "e827f938463e71d4f64bdb190e30b5059b461b51a4ba6fd08bff45b596936b4b"
    sha256 cellar: :any_skip_relocation, monterey:       "209d65ee8c60e79be27ec8b0ba60d665ae3c196ca4916fc5d62dd732a8611fa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fe12a044b5c2994205639c4cb6ea3c1755563e580dbeb05c7fefb5193509b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "047936ebca60b3a74b7848021a96692bdbda1d3cae6fc856d16c106f77276fd1"
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