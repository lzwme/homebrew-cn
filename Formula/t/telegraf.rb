class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.29.2.tar.gz"
  sha256 "57dc7c3050c2d741fa0e0d680a04237aaf7d6a47f4ffa037a509b29305a6228a"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3196801f8c2b524b58fc878b44f225ba15dbc7c6a9485f64acad90b7a95e441"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deb0065002aad90f449c010663af7334d0dfdb05cdc855861b97ade289b06e84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "845196a1bca02bbad081c497244f8466644864a1b60e729552d6a8e3ad591bdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "5af1133c20f18d4f72150447a71e23f316e35f56dd2511794086d468882f69e2"
    sha256 cellar: :any_skip_relocation, ventura:        "61dfd2f8084eaf98f7cdb3cec1e6b19fae35005bc80939e260b07c9540a599ef"
    sha256 cellar: :any_skip_relocation, monterey:       "36f35b61c7525234655110806811067eb271ad3f7c258e85e2c26f59ba69fa79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33b7aff6cd475f17fca0d08ea3d11b5fe95326fe41df4b626026c045c49a8819"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.cominfluxdatatelegrafinternal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdtelegraf"
    (etc"telegraf.conf").write Utils.safe_popen_read("#{bin}telegraf", "config")
  end

  def post_install
    # Create directory for additional user configurations
    (etc"telegraf.d").mkpath
  end

  service do
    run [opt_bin"telegraf", "-config", etc"telegraf.conf", "-config-directory", etc"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var"logtelegraf.log"
    error_log_path var"logtelegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}telegraf --version")
    (testpath"config.toml").write shell_output("#{bin}telegraf -sample-config")
    system "#{bin}telegraf", "-config", testpath"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end