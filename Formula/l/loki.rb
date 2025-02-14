class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.4.1.tar.gz"
  sha256 "8e496f9abc85f7d4fa05efb70fbff419bc581f342574afdb13fd3c4ec33a77bf"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f2e7b10c7b78cbd4e6211e30f0dc7b4b78d5b158ac40d5faa0137cf4cb06de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f865bc2d1ce88bfa16d4ea12ce1121053f95838cf9f2cfe55ec5350fefe0c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d764c1357dadcd38b49da050a9988a7e45d632ba36d382d6e2c5ec29d422c609"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b63648c7cfe3dc178de58d61c0017caf697a283cbb29c9e438570cddac9feb6"
    sha256 cellar: :any_skip_relocation, ventura:       "24d968a524f9a987c81f1a29ab8cd9590d3bf7ea8ce8944f7ba2290229f4b812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e1d274b01c9010203fd92e3c6915c7a5a9999d440ac1688174b018bd0d082c"
  end

  depends_on "go" => :build

  def install
    cd "cmdloki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin"loki", "-config.file=#{etc}loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var"logloki.log"
    error_log_path var"logloki.log"
  end

  test do
    port = free_port

    cp etc"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin"loki", "-config.file=loki-local-config.yaml" }
    sleep 8

    output = shell_output("curl -s localhost:#{port}metrics")
    assert_match "log_messages_total", output
  end
end