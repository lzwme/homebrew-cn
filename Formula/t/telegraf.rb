class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.30.3.tar.gz"
  sha256 "d0a937f73a41b24b9bacb55c5e6e7828f92fe757b87e4a4d2d8d4be646070a1a"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbb8723bc359907a81d3d83f298a53028cd149931bba1ce979d41d5735120d39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88cfeaee533e52e480814af6e6f6f2b68036b517f69612a097a2a252425517f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b16d965053f7fc41e82609f2f3cb47ed3669268699be9e0f1d256299b2f5f0a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab0aa4cb46d4ee708e7d69e40086209f0faa06341ac1f391af555aba4114dcd"
    sha256 cellar: :any_skip_relocation, ventura:        "9b9419cd77a2130046dc80804cb8b1574f1e8f2eccc3716d819d3d4e3023a1cd"
    sha256 cellar: :any_skip_relocation, monterey:       "3c7d9a900b1554497ef54389034e973f4cffd94b012b850855cc98f16c300f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b96b9d8cb64a94ae799dab8659b9db5da6331bc4c7dec3a4cd0d597c6abeb9"
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