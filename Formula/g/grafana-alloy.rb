class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https:grafana.comossalloy-opentelemetry-collector"
  url "https:github.comgrafanaalloyarchiverefstagsv1.7.5.tar.gz"
  sha256 "dee15a31d40a26f1ef44fb20d296784219ad45338cc1186634014e9da6a139dd"
  license "Apache-2.0"
  head "https:github.comgrafanaalloy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecdf0c03518aae1d4401d509ee2f64aecf9a231b009a7d6b573fe5caa44701d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3cb5ac1409871ec8113b853a9bd7c3c5dc242f27dbbfc1a4c8ac23f42205f81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cdb2e941fe3b6e9c94f00a921b9dec1f6103397402c17f6d3466dc74ecb932f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0dbee13d809a205a3807d75a7326d21aa46d430d5a623e6d0c944a82651f22"
    sha256 cellar: :any_skip_relocation, ventura:       "c75b6bef1ae6eb45ebdc3112eed0624e3923fa96c0c516577619311bf7440858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8cadfdd7f101071e4bf8d79a0b2649f9855e5076767743cda14f63f1b69552"
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