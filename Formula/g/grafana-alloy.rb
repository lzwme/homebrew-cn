class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https:grafana.comossalloy-opentelemetry-collector"
  url "https:github.comgrafanaalloyarchiverefstagsv1.8.0.tar.gz"
  sha256 "7b1647ad5ebdd455ffacef045e4a6d6a07b4a703040a5127ff00cf25ea26ba58"
  license "Apache-2.0"
  head "https:github.comgrafanaalloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57197f55068caca3738d2060d8692977ba1c2a02bd139c3badd95064b7221d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3cbaeeeabeb3d75161fb5b2b0291e65d73122f55b94d6f68335d0869175afc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7998ac32ac24a9a48df9f8232e6a2d00232df83b877d6ab297c081361578622"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d4d285e8a3c1c920c2bab4db1e5ddb193308b25ad37559ece6977dfda78cde7"
    sha256 cellar: :any_skip_relocation, ventura:       "ec1c87b1289dc8427b02291ddb6a0837a36a3d6df524e06932a0567caef5eaf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e19ebeb026868358524f7a9aa08e09cf72e79cea4aca1b21d555de17b6872376"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comgrafanaalloyinternalbuild.Branch=HEAD
      -X github.comgrafanaalloyinternalbuild.Version=v#{version}
      -X github.comgrafanaalloyinternalbuild.BuildUser=#{tap.user}
      -X github.comgrafanaalloyinternalbuild.BuildDate=#{time.iso8601}
    ]

    # https:github.comgrafanaalloyblobmaintoolsmakepackaging.mk
    tags = %w[netgo builtinassets]
    tags << "promtail_journal_enabled" if OS.linux?

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    system "yarn", "--cwd", "internalwebui"
    system "yarn", "--cwd", "internalwebui", "run", "build"

    system "go", "build", *std_go_args(ldflags:, tags:, output: bin"alloy")

    generate_completions_from_executable(bin"alloy", "completion")
  end

  def post_install
    pkgetc.mkpath
  end

  def caveats
    "Alloy configuration directory is #{pkgetc}"
  end

  service do
    run [opt_bin"alloy", "run", "--storage.path=#{var}libgrafana-alloydata", etc"grafana-alloy"]
    keep_alive true
    log_path var"loggrafana-alloy.log"
    error_log_path var"loggrafana-alloy.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}alloy --version")

    port = free_port
    pid = spawn bin"alloy", "run", "--server.http.listen-addr=127.0.0.1:#{port}", testpath
    sleep 10
    output = shell_output("curl -s 127.0.0.1:#{port}metrics")
    assert_match "alloy_build_info", output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end