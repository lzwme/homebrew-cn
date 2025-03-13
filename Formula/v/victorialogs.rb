class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.16.0-victorialogs.tar.gz"
  sha256 "5eaf3fc840421babcd3c811d862f28b5fad9cfe377a28c505ce1c1babf2c9a62"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1228014175325ebf7a59a6958b439d70c2ff9126cef92021e3c581a58d431c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932219c952358fcc757e83bb0e2c35ffc08910c71045c70c74ae4d61f685e349"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35b58caae26f75fe4930b8990a839155725e7a9140433893fb6d50448ab19a24"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7c3b7fdca4618240ca668668ca1a59565bdfec248d383706f146bd4ad0c25a"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b080a81f1e9877dc08218af0ce97d6969da55b46838eea5515c213b32be1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403baa66d131ad0b958058b3be8b585a5c32d49e7d786910d577e2189fd4097b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comVictoriaMetricsVictoriaMetricslibbuildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"victoria-logs"), ".appvictoria-logs"
  end

  service do
    run [
      opt_bin"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}victorialogs-data",
    ]
    keep_alive false
    log_path var"logvictoria-logs.log"
    error_log_path var"logvictoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end