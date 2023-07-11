class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghproxy.com/https://github.com/influxdata/telegraf/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "e3e1c42f334a3ada14c1f12538bd2f651ab2518e9eb0906f7edb51e49ac0f49c"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f412dfca50fea92a15a46c27fb6cca956426a48eeb22a95404e547cfa8384e3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754e9e383ad5791a7988ab3a46b1b9969e3a1f73b4f9c419a2ddc89bcb36c4cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e70df23adac390fc44b2423ef768c96b61a0f27a5b94c010f87652dc771d83c"
    sha256 cellar: :any_skip_relocation, ventura:        "af00b2401b29ad7dcad2b9d2b91d8811f8e7069a646f28a8dcac6c0265d15821"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7f9f26428f209994c4f6cbfa19ccd34d628b928c2e1f5a2e1e96697faa0a73"
    sha256 cellar: :any_skip_relocation, big_sur:        "88ea03530e13c7992fb2fb9e373d8b877647b37f9287106e5af015993c193ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40bd035849c87d879ab06b53adb69bc8cdb573c83f13d9573f87d16e25e4ae5"
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