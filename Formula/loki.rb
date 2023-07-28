class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://ghproxy.com/https://github.com/grafana/loki/archive/v2.8.3.tar.gz"
  sha256 "d699b24e1b5f823603502359045a39d0cff3bfec69bc5a6836a16a42bc10b53a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d131fac37564e0e551a570c0797ae971937cc709fc8df1be824e70179951d4f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d131fac37564e0e551a570c0797ae971937cc709fc8df1be824e70179951d4f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d131fac37564e0e551a570c0797ae971937cc709fc8df1be824e70179951d4f5"
    sha256 cellar: :any_skip_relocation, ventura:        "f46bcdead2b258dd2748a27ede06472612131a52b29bcfef99d33cede0f6989c"
    sha256 cellar: :any_skip_relocation, monterey:       "f46bcdead2b258dd2748a27ede06472612131a52b29bcfef99d33cede0f6989c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f46bcdead2b258dd2748a27ede06472612131a52b29bcfef99d33cede0f6989c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c7daba63a81efff36d645950903fb130c7066018ebfedd845b13222b0b09620"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
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

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end