class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.23.3-victorialogs.tar.gz"
  sha256 "04a369496941462f7a56b9c4cea0ed5768fbd65ddd74009120e82079960ced49"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa4c6cab362eec0aad858f14382b99f23599448aff2fdf48303d25da9972710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27727ffd8141d166b2dccd6cbbbe33c763a41c2e38804387eedfdc632f24ed42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d36fbf2a28b2732712f7304d48de09c1876236542fde2db62d641762e939c301"
    sha256 cellar: :any_skip_relocation, sonoma:        "2226b9db6887b8944465ca88a3ce08f2adc698ffa0d6c851ed93167022ab16af"
    sha256 cellar: :any_skip_relocation, ventura:       "38657a5b55d03ce19f7162ae092d9917fa8de83c2264c8543c7a2a5fcb39c145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87499c9599f57e5e1f0bfa703c7a1094e81a03c46b884eb1b0b508709a97d054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac234cadd1d628e5f6cfb65ae43784d051a1c214ca3e3cef01c5141092fcc4be"
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