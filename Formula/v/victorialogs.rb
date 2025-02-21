class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.12.0-victorialogs.tar.gz"
  sha256 "3b28226377a5da8b4283f32857fcb64f3252abd1ca2f3dab69317fdb323400b6"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "452b56718a06c543aa3c159684437f9b9ad592f797d71a033d0c2249a0bb5482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5cd22fb42db96d63f3552728ec8fa28ba17c61f4d3d15f9c635ec51d9cb3fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dae8b78dfbc2fc0c3b50f4ccf54e8c4d95bb5d5c44aa4ab94e3072f285132fb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4510eac70a71f833fddebe1e99dbeafc63d85603c617145b2fe329db063417cc"
    sha256 cellar: :any_skip_relocation, ventura:       "283db157bf3255c0281ac9261baae3f3782e3babdcfcae84eb2eb5234166adbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28c8334fe1c5b601f9c409dbb03b2f6696eaa5442738a6aca379fefcdfeb080"
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