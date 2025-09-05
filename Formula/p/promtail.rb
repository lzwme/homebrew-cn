class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "c2474f291386bd4fb13c8c585df546cb218cb5fa644dabda2afa6b271a57f2ca"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba2864182d105f6415650074e436192de1974b89c6244ecd92f3ac8b5a24ee14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0a6f6e09877da42d42a3e6d559dc35db4deb6040ed7d525fd2bfb243eed19d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0b42976f2241764c912821aa7645b33a0437f6d34310e2fc726ef612126a215"
    sha256 cellar: :any_skip_relocation, sonoma:        "34b29163379169a12c00131069bd1bb6a73471267608c4a8ee4ad0a339c02b57"
    sha256 cellar: :any_skip_relocation, ventura:       "380326a89548e465c3e0ff0bcc9b54d9ef33602e4400e19ba3c2d80aae84d66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04e15579c059ab4ed91189029f51602c3a70bce7ac3c71ac0a76967255475713"
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