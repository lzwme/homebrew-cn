class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "1f05448f5026bff30f8a2b7ec04936c7967b7bb28d86d09f15a617c02071bb77"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb99a0746faface0aa84ea47ae345e2d9b062d3f6dd38e044a904d5abb5a2f6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118f31075e60ec8e826942cbd7e72eaa55b78fbc7765aa4c7589cae7ed2768b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c4dac61503ef8e431864fa509b57140d15f82e0c5d4f590b24093adb1b5c10"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c56c1653596705e12669398c5fa4df3882e0bc051296dd0aac672e38e7a5ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68e46fc0da6b6bae6df3e47e54224068ac3dda003885dd51a1d7d597bb07af08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9690680a66a001ef6f6ff73c8eb65bd40392695ef4b2acc48f9451496b949c89"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
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