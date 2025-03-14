class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https:grafana.comossalloy-opentelemetry-collector"
  url "https:github.comgrafanaalloyarchiverefstagsv1.7.3.tar.gz"
  sha256 "f45657c08d2097cf5dc35199d4f878a55ad58f8767f27867c6993c9ed58b596f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef5ac7377832740d1e2b49122746b9864915b0f3ea001ee028d7c35e6774d9c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c5fa1e5f73357a4abaf6ca9d14831bc388746e491e2b8c0d018062be991bde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a10339da73ab50cf9e3096746ceb1174c743b6f2c739fcbfda92a02c1f94bce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e80a82d6967c5211850b2bb33de3de384b420236935fcc8c36dd8364231dc54b"
    sha256 cellar: :any_skip_relocation, ventura:       "86342199bea3bc0b93b5622497a03191f26602d3b67161ddac00e8374d7e0526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ad023f06260e5dc7ae04f67c7d44271a582639d10414d163ec8a2ea25406ce"
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

    system "go", "build", "-tags=#{tags.join(",")}", *std_go_args(ldflags:, output: bin"alloy")

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