class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.15.0-victorialogs.tar.gz"
  sha256 "b496285d0242647bd34c8a34a9ed14bddab44141fb987e002ddc725acca93a36"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8db0932a9eed103a6f8ac7f26762181b9b66f538d85d5a4744aa32a64fb957c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15b76d6d30e548562588dc08a0e4a5f9342168946647bcc0e7a916f40e977664"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5ec461b86df3aa4f38bab7aa8cde7574c60dd278acea395f7831592372da15f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d30accfcf0f5b06fcdbb3276573260a4718bc2cc1a4497fbd39715e662cdf53"
    sha256 cellar: :any_skip_relocation, ventura:       "a9844a7022d3137dc904c42a88a087dbea556e39d7e0af18f04c878f8dc0c24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9736be5ab38232d37bd4574ce60f4fedb3bd022a0d6464cdd0ed9cde35dafea"
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