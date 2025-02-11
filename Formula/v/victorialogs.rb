class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.9.1-victorialogs.tar.gz"
  sha256 "e941b1422d7cda16e1bc7d3f7736e2ebc017182f7c8758b997b343e96cf5656f"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4e9a1db5d9f709c0ff1a8ced72322f3b3ec89d241669ed7a0f9fe64350653b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30670bf79c10fd587a990a2d557ee233e751aba26546ff6342947743283df9dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03e7978b51055c9af9d0908d9184344332da3c7fea179dfbc8a25ae8955e4b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a342343ec3d41bfe93c06dd621cc52164ce2f7c62b74675f6c4806fc6881273"
    sha256 cellar: :any_skip_relocation, ventura:       "272c34ce7b2f670e5b14571ea4e92d47d5ea2977d41eb7503c7efa163c12baa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c5dcf320fa566fc98214d3b1b847e61ef4d9357892dd943b2d5b2893b4459fc"
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