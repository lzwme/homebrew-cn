class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.37.3.tar.gz"
  sha256 "a01e7607ebdf7df5fe04bb9960b58a7c1d0501f24b55c3e01005de7c930247dd"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d959ed80014584d3756f3d79807eb0cda4e3a3e5503e6539975957de1bafba92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1aec095ca58afbedabf8cef131b138b7b67606bb7768f50b28ed0d1938dd84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ac9faab705ac37484fc523dea343358ab51f2572cacc7352311820bac171cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "396a289207efac4bb062a404adb341720af8424734674ef40477fc09fa055327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bf2d994ee426c96c341d57c800b40bbe432dd4e2316f1609f3283a2f1aa7a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e1d1e12a8a9ba898635fe82629d9cb46e143519a219ef4d1c1f4a9a856cda9"
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