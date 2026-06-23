class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://ghfast.top/https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "1eb33dae2fae7c74965c6e604bc09eaea5836a1e3a81a05659ee65ff2a9bcbb3"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb7c7145b78bf0f3db168f571e7114a8cac38fb246edb34727c56ce616c233d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91cfc4012864f5b52b3787734331925497af067e868e31b374235e1176bdb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5d16c6ca3d852d35439fed3182bf124880a1f70bdece05f7fd1d0652bb13784"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d16132d75d0d4ce4a57d92e29caea7dfe5e1b272d537dc561bac6eabf3d285"
    sha256 cellar: :any,                 arm64_linux:   "76d21bad00d8f1eaaa5d568868e46b527696217140c912c7fe5c4bb18a30f7ce"
    sha256 cellar: :any,                 x86_64_linux:  "dd341a0f97efb5ffa6586db3cdddabc5a8a00f6655a37664ad00763a9aa85075"
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