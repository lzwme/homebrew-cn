class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "232d11feaa1bc9abbb4ea0189c6a017efe7807da56cd8f619a975b2ee663d3df"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3a26a184a6335ab12e1c27838b33dd354fc9341dbea12c2dd9224c36eff2850"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d99b340c9a2ec66f9cc0a742bbcf72568d467a25fe99936f9e64dcac1aefcc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6b832c7fdc24b7c2168a9877a7c66dd9a4fcad49f28db725d3701512d04e820"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77e8143906bf520fa805abcf4de45f190151d9fea2050fd8323e7e6c28859f77"
    sha256 cellar: :any,                 x86_64_linux:      "39cc420b99c5813c8a07ac7902a73f695a66d9b7afa91a182b151926fb2842c8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    build_version = build.head? ? "0.0.0-#{version}" : version
    ldflags = "-X github.com/influxdata/telegraf/internal.Version=#{build_version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"

    (buildpath/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
    etc.install "telegraf.conf"
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
    environment_variables HOME: HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end