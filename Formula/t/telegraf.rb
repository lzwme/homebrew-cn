class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.31.2.tar.gz"
  sha256 "b7b4edb5b392769365380ee9108187db099d1f39678cfa1f4e4cbc723ed41c0e"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d65a9596a5dd7fd30b1446972d2af0742e6e73fed99a2929c1af2dd2983677a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09820395ba7a699ef0484b246de0fe1b9bc9909c430763d2a72087f2fe42e4f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f91dae8e00df7911e79df4b0ff94fd67d54dea430bce756799dbaa6c677322d"
    sha256 cellar: :any_skip_relocation, sonoma:         "357fad8c0be567e6e4c65045bbf5f3acaae6e092cbf8458091efd17ab2d0da44"
    sha256 cellar: :any_skip_relocation, ventura:        "ff803bcfa5d454cbed5d4cfb5c994cf5bae4aef4264b78b741cd7b1bd580fc87"
    sha256 cellar: :any_skip_relocation, monterey:       "d981f9e87b524582f4aa386a8840b3901167ee24a6ff5b224e0199e77399b441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1334f4e0484578067c815b463b70f60004da69c3b1e6f735e9efd190ac757f18"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.cominfluxdatatelegrafinternal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtelegraf"
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