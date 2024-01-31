class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.29.3.tar.gz"
  sha256 "40550312cf489bbda1a208dc8efcc3f4f9c65d8974dcdde20c3f9447796fce02"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48ae285d8edcb834169d376ec2c4c973a937fdc075be3ba02c744204ad980bde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eec2b0cea4d53abcd0f5cec7664473665e85e4a1fed9ec8f5a905ca6cbd08812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a1ab557cc69dbb676ac0c86ffc803cbccb75ad54acbaf196f7c764bf73e28fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f288f56bd4e3317c3394b041e102b12b5a260c610d7ace4e9df0ad240c670f0"
    sha256 cellar: :any_skip_relocation, ventura:        "357dbe53a6129e36b54534b20abf06f4ee2d89300edffc5f3a3705a14ae5db5a"
    sha256 cellar: :any_skip_relocation, monterey:       "20a3122beef776962a024bdb31d74f858b09acc71dfb4a0d4d94a5cdec69faad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91a296ac399efeba86451e3c420df0e0fb71fa74759bafd7f8642f1159801361"
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