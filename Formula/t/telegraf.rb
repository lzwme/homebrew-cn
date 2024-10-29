class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.32.2.tar.gz"
  sha256 "e4f74a64613aa522bd508f8c492876088e4d671a218693448354baddfbad3bb9"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8eaaad1a26eb5dd06d9d7e701b120210714af3211b38f173fb689895fee4ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2c6e590689cc6ec362ed9d595a996d51a79297a4aea6771868bdfe64b24fe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c179b251da47a6021f85eacac89183e503965bda753382f32f5211eba015481f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cb7017c660b51bcd8306a77dad7805d2a33c469363842eb8c363789485f9bbe"
    sha256 cellar: :any_skip_relocation, ventura:       "cac5978fa0a145e7c2dba546306cc0875b479703b86ac2355ad8cf6c3db83257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7575781125e63c53db5f8b332c0492cb0ce9582b7da3ab4ea3a655abfb8027da"
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