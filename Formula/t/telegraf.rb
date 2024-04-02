class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.30.1.tar.gz"
  sha256 "77f01e8dc2e84b6a91f9ad2b5aa80873f53076a1c806c0966267769896e1b015"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "846308542f523706498243d53e3262eb9b80294d56218fa380b9060f654c8937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67c8ae0eacf4fea2f7ed56d79c8d986837bc476b85c7ffd5bd9cd210155d4c18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f7e5fc0fec0efd21bb933c28124bd348bb42693785b38e10f68ca1ca0c637b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c16cc9a7e6bf570342f68e4e8262087fd98139488e10c44b3ffd24e96f407a5"
    sha256 cellar: :any_skip_relocation, ventura:        "a3f1d57df64e3cc30d3f33a8d35589a1a3ed47ffb1a9017d087970cdf30779a5"
    sha256 cellar: :any_skip_relocation, monterey:       "36c58fe375736b4790ec164a1d5c91868c2cc3a6762ba691d44c4ca6c6a3e671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "794bca45193a923d464f085a24f026f453d373b10137443c6f4d9e5cab3c4009"
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