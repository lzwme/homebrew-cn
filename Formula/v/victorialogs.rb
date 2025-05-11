class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.22.2-victorialogs.tar.gz"
  sha256 "a2e9abf336cb0a299d611ca9c7955212b4d6f316bf1ef37e2c098bbf4e47a998"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9577f4a0a1df19c12e4bc9d0a34ce0e3dc97b0d7ead48c87cd5a411c7ac800f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7af0a79edbd056451caead83ad35c56c6e2a1ab67ea0e3e2078f0234880a4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57fce423daf59802ed2fa6227549083f676135a15d7d5eb2663f4069041b193a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3060bf5487bda7b971a1d3ab2e648ce40155f7b80e140f9fa12f47a00042f607"
    sha256 cellar: :any_skip_relocation, ventura:       "90c3abc2b382a747f0f11b14d474f66e394b6ab3a6f5b9532afde1b0cf050ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9954ca0b118c4da6fdbde2339e115381c81b00ce490b7e5815d902e63e52179d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36b946055a52021122e11efd41494fbd2e9b6ceb77a85cbb3bfc09bc797cbc8"
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