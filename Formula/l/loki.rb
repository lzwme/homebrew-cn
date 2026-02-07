class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "4604e23a7a91eff7aa299a269af74b6f9021a4d4f396d33f3b7fec1e91b289c6"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12927745de593ce88c0ad9138a8ef50c5c0be6b67319af314ffa29557a814168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17b53ca3846aa36345812475f4529619b7ac20647527049dd62cdecab81c2896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3f7a0bdf8756af47fbbb8da891f0c46e2efec3d61304c03250b49cdb215a06"
    sha256 cellar: :any_skip_relocation, sonoma:        "351513c16cf37275135a5975dadff3cda64c65345e37da89de7f967f464f3c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e416aad97bea4155900fa169993680a9dd169cc55cd5983703f33b4fd83ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64206305953517abb02a03685796f540ffb6c546ba8b43e4af7be2541aab50c2"
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