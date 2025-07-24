class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "0a1b9a001ccde90cf870118ccd02a5be4f7ededbac4c8c2ff556f0380cbc559f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab56f56937bf567635033c3e8abb019ad89e52e98807f1bd31cca7fe2ede875f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c9324aaaf1f7f4182bfe65523e1c79fb11db670ff53dfafd6c5281d7abeb9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2033e89f4f0a1edc20f296c48c0cb0a21dc69610838dfdf00d5212cdea862ba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "543279a6ed093d3f335e390f979184584658d4b57cbff69ac5a3b96166c60762"
    sha256 cellar: :any_skip_relocation, ventura:       "539e99f8965343c61edb377c4f84dccf89af1ee246d73a8cc04a312ac7da609c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc7dd8dd2af0a81683f294cbcf665f08190ca2d5d61db712bd08482133b2142"
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