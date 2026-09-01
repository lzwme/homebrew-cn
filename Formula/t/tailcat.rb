class Tailcat < Formula
  desc "Netcat-like tool over Tailscale's data plane, without its control plane"
  homepage "https://github.com/tailscale/tailcat"
  url "https://ghfast.top/https://github.com/tailscale/tailcat/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f3e87753aa45f8be249a2708a4220748fd8613f9ea0d0435a48ffedf8d724247"
  license "BSD-3-Clause"
  head "https://github.com/tailscale/tailcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6716ae745d98ebdab4544ef6ec8a3d2cdd352ad87e8720f3b86be5ba1023d10f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87bf63e4cc449a8413183ae6693107939d90f60aab6b50139e87ef46c117b152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "399919aedc4d6a52ef18052a9236b467ac93a9c69ce8906ce2f40e98bb173e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f6f01a54655c4d32faa11a5e6a22dba43071888fadd9a31a628f0c655e0009"
    sha256 cellar: :any,                 x86_64_linux:  "13c2f20c2976259b75205861117811cbeeb7d500e2f24b83bfd01a10baa11659"
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