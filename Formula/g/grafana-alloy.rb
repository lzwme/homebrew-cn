class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https:grafana.comossalloy-opentelemetry-collector"
  url "https:github.comgrafanaalloyarchiverefstagsv1.7.4.tar.gz"
  sha256 "014aef38d7f41f35346398c2b47ed35c067714aca86658dc7600dabc126ce6b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642f5644d32c367a82d443349c95cb62d14d66bfc067596cec0ad7532f4088c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c24043bf64980e8276cbabc8ed20556e524164139a78b37d7efd6a1304ef9add"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f3e49c144c48845f19f20d9dc92babd5b40034f05b4c61da61bb1459f1855ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8850c7a2415002222f558037e327b82a654d232ec050bbf2be9e6c1d7d33339f"
    sha256 cellar: :any_skip_relocation, ventura:       "c22fc198109de160cfef3064cbea8c6ca1f43f19407dd599c5800cbff693dcfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84482faf1253826bd9d733d23347c063e7c81fbb75404bc8bf93ca7d47cc2c7c"
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