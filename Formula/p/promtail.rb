class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.6.tar.gz"
  sha256 "4deb052c2bac06b1509298d232c83740e71040f4e6c6c823329d3c44fc5c8b64"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "844183c6ef870c199d974b86b9d50d369944eca71e9a9a47d8d9b6462da2dccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c0a5150842878a25726d31da9a6eb68a9bb165989a3ffbabfb19330b70b84a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "400c8b486eada5c0f6ef8aea6cf5347c958dac0da2ca79eedf25f9b57ef1e3de"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5d8ef614fd77d159de1be892e687cfeaebfb3b955b39925500002f9bb54ba9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd9d1fa87fd7b036c0c151e82c301fe433b464811831bfd219f493593df7d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21692e97d4d40d79b5eef4b64a6408d8369bab22ca0290e87a3d17169a97d629"
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