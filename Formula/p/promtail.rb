class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.4.1.tar.gz"
  sha256 "8e496f9abc85f7d4fa05efb70fbff419bc581f342574afdb13fd3c4ec33a77bf"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f603fe20475e16f98bdc46fa4ad1216957a98248ff8b51769e4ca3cd7f0ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d99eb7a8513cead8bad284b6e615da6df38b4484406d490d3c404eaa71613976"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf12520b675704a129b24ad63731419e6d0de887e8b713333b05ccd97c4225b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "25e6bcb58a1af6f113cb64cf1a401b46ecc65b3600f982358af9bf628708774e"
    sha256 cellar: :any_skip_relocation, ventura:       "635888a6aadab951239c86840b86866e2e832850ca3ca9c176db18548158a406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "786a680397bb5e343afc1e4f98a794afeafbfc35b2b1e21cd1128f65347303d6"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clientscmdpromtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin"promtail", "-config.file=#{etc}promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var"logpromtail.log"
    error_log_path var"logpromtail.log"
  end

  test do
    port = free_port

    cp etc"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(__path__: .+$, "__path__: #{testpath}")
    end

    fork { exec bin"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}metrics")
    assert_match "log_messages_total", output
  end
end