class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghproxy.com/https://github.com/runatlantis/atlantis/archive/v0.24.0.tar.gz"
  sha256 "7bcab73aed93e4031256a813f2663420b2bb95e113f146475d4a186cc77a557d"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15a45df2e1f7468af9fd4ad57b6a96b504e34c5f458e25de632d83989d0096ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a45df2e1f7468af9fd4ad57b6a96b504e34c5f458e25de632d83989d0096ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15a45df2e1f7468af9fd4ad57b6a96b504e34c5f458e25de632d83989d0096ab"
    sha256 cellar: :any_skip_relocation, ventura:        "25d913a659c63ab0ed024e61c8865fa6c451d737484a82e540eeadd3e12cbeb2"
    sha256 cellar: :any_skip_relocation, monterey:       "25d913a659c63ab0ed024e61c8865fa6c451d737484a82e540eeadd3e12cbeb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "25d913a659c63ab0ed024e61c8865fa6c451d737484a82e540eeadd3e12cbeb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140ec9e977e8dde47854b4a5dd81c2d6686986cd88edea68f121b45ccd732154"
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