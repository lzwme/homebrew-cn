class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.33.3.tar.gz"
  sha256 "4249e66f1d4e7b9283173d9a0904d429b7d44ff328277543da9e93669d0be48d"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a4cc6f8a75ceda69a5b36f9c1459511c0c0653a811e6d6d54694661067fabf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8937bb32d8bcdc7c9cca82085539f5115ab82226de7c76770f75592e798b9cf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f843efb8ec233fb5b8459f9c1767e1f36ab930fadaca5c4eb849803f5731d328"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a68020d9aeb135185dcee0f93efc6ddc7fe8964f4d573a0b1b2ae75c38129df"
    sha256 cellar: :any_skip_relocation, ventura:       "82baa5c5cac026674c17fba975a8c9c31909a0a327b12daaccff77b0211c1e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21f33746f6a058f3f4b90bc80504c0b9bf62d9c335a35deade0c1d882d8a681"
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