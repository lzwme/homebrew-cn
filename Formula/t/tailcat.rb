class Tailcat < Formula
  desc "Netcat-like tool over Tailscale's data plane, without its control plane"
  homepage "https://github.com/tailscale/tailcat"
  url "https://ghfast.top/https://github.com/tailscale/tailcat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a2177d257ac7a02d8ba0fdfcfa341113d97ea0cf7597dbb0fff851d8c341d8e9"
  license "BSD-3-Clause"
  head "https://github.com/tailscale/tailcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d377cd199792daab0a933b0bad37fc24d7a191849325ad30a71b69444aa370b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344dfdb996d41ce74c5b95966cab66c57fe9824e69d37404eadb2e5d6fee5c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad37cf7c1113e9943d226af6eaed84af11635abd2bc6214caa354dc329c543fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d16373e5ed7d8543feac20cb07a0178cb8b253db33934055553b30864b8738d1"
    sha256 cellar: :any,                 x86_64_linux:  "1056b538360640a408a057d51ad80dfb700fc4bab3c61c5a46ad00f9a0db5cc4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/tailcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tailcat --version")

    derpmap_url = "--derpmap-url=none" # ensure no external network access
    addr_file = testpath/"addr"
    server_stdout = testpath/"server_stdout"
    server_log = testpath/"server_log"
    payload = "hello from homebrew"

    server_pid = fork do
      ENV["TS_DEBUG_TAILCAT_LOCAL_DERP"] = "1"
      ENV["TAILCAT_ADDR_FILE"] = addr_file.to_s
      exec bin/"tailcat", "--key=new", derpmap_url,
           out: server_stdout.to_s, err: server_log.to_s
    end

    blob = nil
    60.times do
      blob = addr_file.read.chomp if addr_file.exist?
      break unless blob.to_s.empty?

      sleep 0.5
    end
    refute_empty blob.to_s, "timed out waiting for the server address"

    pipe_output("#{bin}/tailcat --key=new #{derpmap_url} #{blob}", payload, 0)

    Process.wait(server_pid)
    assert_predicate $CHILD_STATUS, :success?, "server exited #{$CHILD_STATUS}: #{server_log.read}"
    assert_equal payload, server_stdout.read
  end
end