class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://ghfast.top/https://github.com/jpillora/chisel/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "5c25f054b64814f770725593db525faa1999960aecf4eb15c86529dea573c431"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad5d2047cd55542c7bb93504bfebfff4ab761b4b62ffb84967039f0feac00199"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad5d2047cd55542c7bb93504bfebfff4ab761b4b62ffb84967039f0feac00199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5d2047cd55542c7bb93504bfebfff4ab761b4b62ffb84967039f0feac00199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1962a1f29aa7937421ac5587d80cc4fc90e0afe52c403b2aec641e056f5d8473"
    sha256 cellar: :any,                 x86_64_linux:  "05c553616548db7ec817e3d6ac584dd02a8bc1bb90e4f6394b39cb2fb21dc208"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  def install
    ldflags = "-X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel")
  end

  test do
    server_port = free_port
    server_pid = spawn bin/"chisel", "server", "-p", server_port.to_s, [:out, :err] => File::NULL

    begin
      sleep 2
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end