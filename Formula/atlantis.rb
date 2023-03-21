class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghproxy.com/https://github.com/runatlantis/atlantis/archive/v0.23.3.tar.gz"
  sha256 "9bcf4aa59d07f45406f466da7e8a4a68026ba19d2185aa226b6752e3614c1b80"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9ea149877bb2c0ffe64b8818eef04745f7eab8133e6dc752bacb4256c93065f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9ea149877bb2c0ffe64b8818eef04745f7eab8133e6dc752bacb4256c93065f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9ea149877bb2c0ffe64b8818eef04745f7eab8133e6dc752bacb4256c93065f"
    sha256 cellar: :any_skip_relocation, ventura:        "bc6bd2226bceb1b1f0925a485a33cd5bc5ced115508e85937229a3396c1fe0dd"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6bd2226bceb1b1f0925a485a33cd5bc5ced115508e85937229a3396c1fe0dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc6bd2226bceb1b1f0925a485a33cd5bc5ced115508e85937229a3396c1fe0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9510e225e145363e6672a9ffb2caa03c376420fe20d92b1c95a4482b97daf529"
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