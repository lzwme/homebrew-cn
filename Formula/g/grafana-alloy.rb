class GrafanaAlloy < Formula
  desc "OpenTelemetry Collector distribution with programmable pipelines"
  homepage "https:grafana.comossalloy-opentelemetry-collector"
  url "https:github.comgrafanaalloyarchiverefstagsv1.9.1.tar.gz"
  sha256 "d9eaa0719b9264b47d30ad459d13535d9e51815afcb089245b10eabffb14793c"
  license "Apache-2.0"
  head "https:github.comgrafanaalloy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591ddacbaca141b624d29106d529d0de4d17b2abab1e4304a14059608ce1c92f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cdac5d397d056e0395f02b8fb282d0d501fcf8e4f5a244d26ae4c4a6bcd243a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ec6f86d4d3656bc3235327a73a7ac5397ac14a7afc4daaeedc7ce44be2f3772"
    sha256 cellar: :any_skip_relocation, sonoma:        "24cfa5132721635ddc04e80ea9acf15f8fa5f71a67bcd2a55aa1621006b1ceee"
    sha256 cellar: :any_skip_relocation, ventura:       "59e14e87014c799c7f61f709f01e9f33eb913d2e4073a3349070024ff200ab18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ce85c841c0463bd6c7ffaa4201eabf10b84d66d28d89b846bc80af2fb7f0f6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" # for go-systemd (dlopen-ed)
  end

  conflicts_with "alloy-analyzer", because: "both install `alloy` binaries"

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