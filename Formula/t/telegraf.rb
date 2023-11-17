class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghproxy.com/https://github.com/influxdata/telegraf/archive/refs/tags/v1.28.5.tar.gz"
  sha256 "8b0c194a5c1e24caf3b5fdc24556cec1870ef76aae9022e37772d9ba74770186"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a61ad3dd184945b9affca08ad4c7e088ff259fbda04650cd7405c9ff72d758b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0acefcbea1e87a7938f5074f7b6b8f0a5fdff0281ee50cb8640a066631d6ee0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1826c37aaf96ebc521d1677add3043aef561c56ae3d0a45d801c92cfca44d57"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c73112fb361ebe03af20be8d0c7e36be9339c3546b947b87dd40702a2c976f2"
    sha256 cellar: :any_skip_relocation, ventura:        "2037f7492deaaa6bf18780f10b881a2afbdd0a83f57a670d0e183f8443172bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "d298fc91cffc3f0cb5cca472e8b7b703a73a2d1b54237f23d26a7bd90c31847d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd15821a2d059c899aab084a0b20111b888c09bf0626d06bfb74893cff220d7"
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