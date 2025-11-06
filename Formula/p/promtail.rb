class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.8.tar.gz"
  sha256 "4441408c73dfa5d81f1e26d7b608d3cd943c84132a28f406162b24cbfc2db3e1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d2c7a6be80a6b6e8b2f7b282eb04ecc38d3ca1f6d5e01ba0e43c620b0e3abf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b433092a885476b2626dc7093adb8a4743552b2bf75a991899d9969c3601b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c64b6f32fdfefc8513d5d70f3ce1c078d8ce6502cefb55b3b0efb4989833b831"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c1feeb4c2ef45e7a2784d4ae0eab09c13ac36d7e09973bc490db558ecdf98c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c7583c49a925da9db0bb46492eb6263c8cdf30232dbc0eedbe4293ff84a5dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "741f2cdbb6ba9fff38cbb8ad22ea2231e84ec75eb6f831ed71115c2ca6650de0"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/loki/loki-3.5.1-purego.patch"
    sha256 "fbbbaea8e2069ef0a8fc721f592c48bb50f1224d7eff94afe87dfb184692a9b4"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end