class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.32.3.tar.gz"
  sha256 "56d274ef35355f1f19160442fb75fedbcb64e9ae741184b680e5b9282a9e4436"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ad4e5b7f3d974d2d4369ece8395360d709635167a43e0165f29cb246858a340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0526070fa2f0065371568021844b5e9f6b1aa89cf9772ea98743603b8a48b2e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abf7952c2d896f26d3e91456d248bc2d6f654d74b1938854a8abc6d9e5ac8304"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa2ef0a6c8cd5f7401d1185ab7f92b1e8c35e2f30c0fc8e78bc1cf6a4131743d"
    sha256 cellar: :any_skip_relocation, ventura:       "5efbd1e07c0a46adc10155ff5f2f640247ab3b922fceae7f26ddaf448b1ee9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3927d806914b41f8c0f7952a1d996c8d497127eb5be9497d9f0e69500ed97b3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.cominfluxdatatelegrafinternal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtelegraf"
    (etc"telegraf.conf").write Utils.safe_popen_read(bin"telegraf", "config")
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
    system bin"telegraf", "-config", testpath"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end