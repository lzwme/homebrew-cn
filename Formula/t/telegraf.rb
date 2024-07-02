class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.31.1.tar.gz"
  sha256 "6b6c05cd121902d5c0dd054e1e852434e47881c84a6f6468a3a082f81978b8b1"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7207b1ad16de33bd4fb730c97eee11d816055850bd39bb48f467eb204b4b4cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54e5661e8c5af8f03ddddac1af0b17dfb6d38e2f7bcdaebca3347b586dea56e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b455d7c049fe3d257f8d06bd9052a25aff7f51d48a1db60b25086dfd9620f74"
    sha256 cellar: :any_skip_relocation, sonoma:         "01c55014c1311024c67d409bd8e809a103b42e7071f3224d9a9b9d7a279d3025"
    sha256 cellar: :any_skip_relocation, ventura:        "b8bf7a2bff3950b447e811271c03de9ddca08f2fbbcc36e54bcb021e53a3b5c8"
    sha256 cellar: :any_skip_relocation, monterey:       "bc8d9a3e2d8317659578b328a912182b145da0917ca4f15c815ff7d12ce084a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88747893302731173d0827aebd459d47ae03f02f014510a332542acecb173482"
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