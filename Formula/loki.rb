class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://ghproxy.com/https://github.com/grafana/loki/archive/v2.7.5.tar.gz"
  sha256 "8bfc01da348e875ff7a999af3842a14e2c698e06facdf486754127991d6b8f19"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3359fdb5658176f90bab4d74a27e32cbe9d176ea107be25a99ca760e4ecf38ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70c2c2726308ef2fcfee1c2b362e14f721a5b495f7e72d1d3e344e59a952248b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fbba43ec5f00cb447625dc746abf6420c6e3edd82b482e4791496248ee51ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "28721be6e7aa5a13acba77ca102cc1f24ec5a43d26078c7f6077a6d4f50213ae"
    sha256 cellar: :any_skip_relocation, monterey:       "c681098bd5f438ca1f5aeed4f2906ba8186f7b6386c8db1ecbaef4a4b6bdd0ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ceef78fae1ec62344ae1d57a577f88f94c3dc2f316e58094263f241c15974e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac32998336617d0bf19d35a92a9e7b56e4f4f2d251b28c4426526a9ca2f8e02"
  end

  # TODO: Try `go@1.20` or newer on the next release
  depends_on "go@1.19" => :build

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