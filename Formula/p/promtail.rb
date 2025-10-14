class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.7.tar.gz"
  sha256 "a3ffbdc68f3481444c16a7733e4640718af502bcef25d592e77d03da388c4aa1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a90803389587419ce932b5725f5e821696d10e8fd223615703873216cabc182a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05d363a2b977704d9005efe5c211fdac8c0e902ce5945d848bbabdf4526b746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eacdd12a3e96c927dfd5a2123e556e45262f8b2fc7a43d452b64790fab5d113"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccb75da4b340e2d59b8dd842ad51fc86bc6efeec082c1d36985f597cc1a2d587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a2da8e803cf28d2a963ba39ce1fd6e3793ca1ea8a064e2beb7df78022bc3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b030589a4c39de94111373d735030f9e3b45c0560dac088ea566c2507d5dc90a"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/f49c120b0918dd76de81af961a1041a29d080ff0/loki/loki-3.5.1-purego.patch"
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