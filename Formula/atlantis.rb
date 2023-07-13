class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghproxy.com/https://github.com/runatlantis/atlantis/archive/v0.24.4.tar.gz"
  sha256 "3600ea61eda49a8a681bfe6f1646676b08d599a6f45bc36e8f296500cbfa0c35"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f5b3fa781540a1255cbca892bc735cf292b78808d803e017079952dc7c59293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f5b3fa781540a1255cbca892bc735cf292b78808d803e017079952dc7c59293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f5b3fa781540a1255cbca892bc735cf292b78808d803e017079952dc7c59293"
    sha256 cellar: :any_skip_relocation, ventura:        "6f79e58cff1b5d2c7c7ed6b82664a172cfce8c75fb8a893644c37ebbfc5c199e"
    sha256 cellar: :any_skip_relocation, monterey:       "6f79e58cff1b5d2c7c7ed6b82664a172cfce8c75fb8a893644c37ebbfc5c199e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f79e58cff1b5d2c7c7ed6b82664a172cfce8c75fb8a893644c37ebbfc5c199e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ec19f768c55d70bf3d995551f3ad12b3232a28e59b7f8843837e9f11ed0c87"
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