class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.35.1.tar.gz"
  sha256 "788f9b86e628f49e341dae8eaebc585c12fe2bfcf893295e2600f75869cf6c11"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38b1e0205ca070e53587c21627ae1d74eca0c3020f96ff821d515887307f27f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be5844e03c0b12a7bb2d20e258ba4f8a5124e8ee2745199e7ad9b10ec517ed7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2d9dfc0be3b2505987a6b48b7c7be88e38ab4bbcb9c9e4ccf69620f238b062d"
    sha256 cellar: :any_skip_relocation, sonoma:        "188b8d261443d58ef0318cf0e62c90c27024bda9ea90dadecc73073351cdc2cf"
    sha256 cellar: :any_skip_relocation, ventura:       "ce1a5c80c6ad2b26e0098468e139e0779534d620e569de23cb65a0a2908c95e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65cb24e9bb33ecd2feca6fc60e817cdd2f404dfe0c2247006c7e03f2b5b12bd7"
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