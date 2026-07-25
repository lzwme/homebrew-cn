class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.7.4.tar.gz"
  sha256 "22edd28b032b8c976a8ad971f8df378dbe614c39d0a2ad9663e629f4e21bdf37"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13f0a844daa32d98607d3c8617bb8968950fa3f72c49017b1f96354949783ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99658e1485387a22c248caaacd6f0b7d787e55809d6f05aa5ac49378670259ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02729e06d56a3bf55e8156e2878dbd8c83b561104c51e50f9902c87fa7d7fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "266ce0d79621f74813217995c89af390b2b996056a70de7f72898812e11fc083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0195ab349ab6577557ede95cc573ea3f16571b13838f886fe73aebfc33697674"
    sha256 cellar: :any,                 x86_64_linux:  "0eb07b3cc4e6b28e60ab61cdc07b870eccaf060515af85ff4b0c2c89c4d5e07b"
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

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end