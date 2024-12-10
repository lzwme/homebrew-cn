class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.33.0.tar.gz"
  sha256 "ba6d46d75bc9a113ffe90c5f3f8aa7d75e2305f4cc833dc174898c253be0ae47"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36bfacace9b7f03c61804ffc31eeb4550162c474ca49afbf44f969fdb31b5ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1baa6785bba4ebc8f75e859a7ab2ef70ffdb603198c37063e4262e276b22b86c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b55234f104fe81bf4b55db10014c555f3fa1b1d112a70e477e019b308b14073"
    sha256 cellar: :any_skip_relocation, sonoma:        "50ac65381128b9baba4d2ec735b7675e784ef295d50390231d0a5735ac03d38c"
    sha256 cellar: :any_skip_relocation, ventura:       "098203bea382183a42124242168222993fe8b68a3a5db68467b36d438b27f471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a9b90f63db837c7e372c8ea2e57c295b7e22768071df084c51b8e79623bfa4"
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