class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://ghfast.top/https://github.com/erebe/wstunnel/archive/refs/tags/v10.7.1.tar.gz"
  sha256 "016cc051c48159cbd7a2b172024ae70ca7e3db298022828fdcc6b7324aa62d85"
  license "BSD-3-Clause"
  head "https://github.com/erebe/wstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da6e243d21ecd91e7ed8e377ac2d71340fce9f959f2939b958333e8ef86f23fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24db473b1fa6b0587a17a8a299b6e938fe2a7cea19f919f2c097016771e577f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec33cc4edfc72971f8c2aca7755c8dc69b58e0c24b57cf60cc431076d70cbcbe"
    sha256 cellar: :any,                 arm64_linux:   "cf99f39da63e674d7662f24e77aee225592133f81456d64d8f0674db4e6c1dd0"
    sha256 cellar: :any,                 x86_64_linux:  "e32bbbe4a06fc6bef324e0f6f18eb34b9073bb1775d1a66d6a111e8f4e097085"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
  end

  test do
    port = free_port
    pid = spawn bin/"wstunnel", "server", "ws://[::]:#{port}", "--no-color"
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end