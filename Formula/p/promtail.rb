class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "4604e23a7a91eff7aa299a269af74b6f9021a4d4f396d33f3b7fec1e91b289c6"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cddeade89b45f025e5e1cf8c5d82fc630ae0f50a5fbcad85f436fe6dd252faf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c153fe4710649cc98b925f45cadcb97bef94ec86e3610fc25d5742021a008883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a64702b96f16b12805597bfe9db7851ce73331d0eebfa9ba969e7b53f4e2f4f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2a3f00634a647b6a5564cd045c074deaf566e949254176178df12bfe0c77b7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb464856f989c4d8a47911ee1ff790da6f9edaa822db52f7f079b244d5f00c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2f911e8e515bd8fafe7d70f9a440525a94d8dd0753b0cdf26c2ee91a76e548"
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

    spawn bin/"promtail", "-config.file=promtail-local-config.yaml"
    sleep 3
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end