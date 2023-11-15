class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghproxy.com/https://github.com/influxdata/telegraf/archive/refs/tags/v1.28.4.tar.gz"
  sha256 "db8c0486894d159248db3d61019f8b3d6e1899c143913b6f142ce8c3ab2398a9"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "189c47f716e9824c5fd203ac05cd1f8db48fa11a62a96c29699bd9b8b27c89f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0ba93d00e730726976db57d981101fddf36e2f2b03cf9e0be9ae2586142c937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c319b7ff8b5722b3a5a44866eaf8cd7caece57852e6f9d932ffd46aad4f6b93b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0621779747fc646bea21799e38b43814bf5b1d3bdf5710d78ffcf055c01fb816"
    sha256 cellar: :any_skip_relocation, ventura:        "200380835ebdc87c599dbd480e6eedd5fd2496d49074af274b18064e8524eb9a"
    sha256 cellar: :any_skip_relocation, monterey:       "0f4032ecacb2f7f28cdbebc463fc19d1e0fb12f909093104df9c564051a536d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68162ea1537b233ae38aff490864f9a624cf2dd8946fe583ff4dcac3f9340f16"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read("#{bin}/telegraf", "config")
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end