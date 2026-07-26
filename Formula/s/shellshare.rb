class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://ghfast.top/https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "a5b2ff7d9b6c98e5642da320641fa45f8edb0777a1ace0d71b1d89109536ebbc"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ded23a3824b4b4e37f79eb77b69ac4005e17b5c3cf5858fbd134a40eb13e965"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4406f4ce46dd99d39fc8fc85c13d0627f81aaa90b7e1d3410861fd51b06b9ab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4fef84e6958f262480352d2c17edacf588b19f168d1795fc0690647ca9a4a4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3718fcbc6ff6b99ac6f2e57a717c855bb88cd2f2a07e552efe8534be00f2fc1e"
    sha256 cellar: :any,                 arm64_linux:   "35d5fd1f28bf7a6ebd08911a22c06d310d67dd3c4f65bd390d247ae3c84af774"
    sha256 cellar: :any,                 x86_64_linux:  "b27a069166b51d0583fb971260195df93b17b98d9d0ba06c296f735731cb0814"
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