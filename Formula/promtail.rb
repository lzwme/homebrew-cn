class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghproxy.com/https://github.com/grafana/loki/archive/v2.8.3.tar.gz"
  sha256 "d699b24e1b5f823603502359045a39d0cff3bfec69bc5a6836a16a42bc10b53a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6441fbe5e5ce34832f1a1f043ecfa7a2eab4c9a07b6edb816f5f4da3b5ab7cf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6441fbe5e5ce34832f1a1f043ecfa7a2eab4c9a07b6edb816f5f4da3b5ab7cf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6441fbe5e5ce34832f1a1f043ecfa7a2eab4c9a07b6edb816f5f4da3b5ab7cf1"
    sha256 cellar: :any_skip_relocation, ventura:        "b83854a686657c4be7dba17bf8a574134e119fea7836d939bc891a69b2d6c6f8"
    sha256 cellar: :any_skip_relocation, monterey:       "b83854a686657c4be7dba17bf8a574134e119fea7836d939bc891a69b2d6c6f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b83854a686657c4be7dba17bf8a574134e119fea7836d939bc891a69b2d6c6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199820bbe81a8d7bdb34f06d246153c8da805f770d3b839e082ae5d4d86fd521"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end