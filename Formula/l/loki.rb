class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.7.5.tar.gz"
  sha256 "e9279bde2721bb80a3c9a4918ce7b707374538e2901c302ededb7c8618d6614f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39b4d62d04d7219ddf2f81bd91c011df4beca22781ce166cf5d06207b8b19947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e238ff3f6112a06acb6e56a0fcf558f62dbc5a7d27e3f7e4edcd7f33b90a8589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35eb60f6c926e937ec49d53be3288c4ae9d4ee4dac24f10660c9c28d40e9261d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b552767824aa5c7053e7a125da5fb2599715225a1d518e501c91c6d7d0254aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f7a5f1c15218aa5a5075dba24eb46effc2c848f6cd9b073a172087bd320201b"
    sha256 cellar: :any,                 x86_64_linux:  "935d9dc90472a64957862a6f5cdefeecf88c38eee790fee0fa4f2af598c69131"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end