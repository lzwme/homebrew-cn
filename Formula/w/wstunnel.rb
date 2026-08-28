class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://ghfast.top/https://github.com/erebe/wstunnel/archive/refs/tags/v10.7.0.tar.gz"
  sha256 "90025bc4ee46c8b1abffebb057a59fb0b3a4668eba58822c1b3889b5badce92d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28582c6575d5a42b871833e6a35dd95da3606be725771e5b6b87969624086a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ded8fe3aa52855536b7c7b08223c88525c614e55a6ce15106cb21a204b816fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c15922def12ee6e7a2054fb024a2a93ea4de580709ebc933c91172e1a0ed6e"
    sha256 cellar: :any,                 arm64_linux:   "4c187cbb5bd153ff76e9839971cfd96807369d008cc3f27e009420fa49e5ebed"
    sha256 cellar: :any,                 x86_64_linux:  "d02db9ecc0057dff3402133c9f9f7abaeebd6e1c3194c4122706a2a0d75c19dc"
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