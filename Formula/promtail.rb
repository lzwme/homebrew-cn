class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghproxy.com/https://github.com/grafana/loki/archive/v2.7.5.tar.gz"
  sha256 "8bfc01da348e875ff7a999af3842a14e2c698e06facdf486754127991d6b8f19"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbdbcf1aa33170f5122b4ce307736025943f281c30166b8644d2d014bd9596ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3cfd2a3e13001e7eb82607b61cd87a21b22752d41e3942ec346ef243e6b8e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "732a450d0d333442b3b8c56e80fa513444e1652919195b4cf8d80d74f069097b"
    sha256 cellar: :any_skip_relocation, ventura:        "b54b24079073fb7aff0d8108baeaf3c7c6daf7e7dac29b1d96d6f8d44dfaf92f"
    sha256 cellar: :any_skip_relocation, monterey:       "d720a4a7dda5add69ef108303d6d0a96acd28e2fbc108d00d43575f7f3b933f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a10035002e1b3fc599273bfd1d08bbbdcea28858a7153b63324741177a952737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "762bacdab267d83242d904e6d0eb8d1b327006d9a87310ea28e41a8fc6ac7478"
  end

  # TODO: Try `go@1.20` or newer on the next release
  depends_on "go@1.19" => :build

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