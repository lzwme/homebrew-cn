class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://github.com/vitorbaptista/shellshare"
  url "https://ghfast.top/https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "49ab3ef73c7fb77be482950a0ee36e9d2cb497b06259ade9f7a88f4db672e1bb"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07cf8063e892c8e7d5182964bfb69e7f8018ec96860da38d5c2a8e026e2a7faf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c5b375dc28d83ef52146c9dcdd5924ed32173c5a9063fb7d5eafb17f526012"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01849ff8b7dc458956a429fce49179c3251ede0205cd68230296c4bdf6d4794a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e191e6690c9416867a805f6680c4dfa658f28ae9b2d3d64221e16872239426e"
    sha256 cellar: :any,                 arm64_linux:   "85ac44fc9b671ab639009758c9f0273f6b057b54c1a2ee014ae6584e7e55983e"
    sha256 cellar: :any,                 x86_64_linux:  "4c712582c5083e580b031dad3c9d9b947ead124a5d71e39f95bff604b04118e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port
    pid = spawn(bin/"shellshare", "server", "--port", port.to_s)
    sleep 2
    assert_match "shellshare", shell_output("curl --silent --max-time 5 http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end