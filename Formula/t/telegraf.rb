class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "18e3d7ba0a8e8ac1c8e8b619a5d97a704cfc9ea3cb49903d3894f0259e2f4a1a"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f26636d0908044da74106f63f6ca67deedcd394cbd649a742ef0254dc9f9d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f068b23456f7283ec2d3e1ffd47a5bd26dd5baf393496f82d2991f64b292c604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15256d3b4aaea977cd1bce0e81f2824b21d734fba2a414839d688c5d8ff92f66"
    sha256 cellar: :any_skip_relocation, sonoma:        "135d18f731d206934585d35d9c91651f7a7ab740a0107c2a4d7210ccf56b9f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cebcf8c6c4a9632dcc87a74c6c4970a461aad4fe88c954a875b2c5c2755f1d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d805edd3c920cb9f271d5bbb1d89645762cbabc143790f0617f92863b344ff"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "0.0.0-#{version}" : version
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{build_version}"
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