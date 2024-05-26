class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https:github.comerebewstunnel"
  url "https:github.comerebewstunnelarchiverefstagsv9.6.0.tar.gz"
  sha256 "c7d46024aacecb6f5f1c5c7a7d4deeb2a42485cd0f9eafc5758fb7f26e173ad5"
  license "BSD-3-Clause"
  head "https:github.comerebewstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3299ebe773456dabe2653e1e51db14d32e2a272698581aa717d6dff01ec31a81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "171ddad34f4a740645de123bf63b6502a678cd222a35a6188d4f83d8226d03f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae362c1b3b8e4ad2c631a9d84bbe8b7e01f078de1af0747bfab34703148bf5c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cdf2470b7405eeebcd9d22c5be5d6585c7cd86ea77449581afb31097fc15332"
    sha256 cellar: :any_skip_relocation, ventura:        "a92e26c3d735601e9bb7de21319c357659d50d105933529a0c2dc267e19b8dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "f7aa8d5e1355197b98df5796c5dd452d48a72381aef50dbfc4f9ff49dac5e1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4213c5142593e3ec31137b9916033188ae394b29ad518189fe1a5c79dbfb05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port

    pid = fork { exec bin"wstunnel", "server", "ws:[::]:#{port}" }
    sleep 2

    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end