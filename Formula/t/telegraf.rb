class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.33.2.tar.gz"
  sha256 "b91e285d816ca8748ab5cad14b73e61bf820f214ad1ac5d86ffec7979c1b64b6"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94be4d63017fbc22f365959f4b0ce4a753c1787b3d7f84a5dae04619c722c30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2461b380d9b1b7319ff4451ac10ec84e6259ee7f6c70bd2ecfecf56a8cd1f94c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f58b5cb279e6994e5fe61df805d0407f9b5160f568638e0d0b5669291018ca00"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcd9e0501a4b284974f33666b4c51053ae0b93b00b96b71623aab831ce580c50"
    sha256 cellar: :any_skip_relocation, ventura:       "410e227319ea47a5be146e439ea146585536691b6cc90e4fcc6a237ad9162cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d321331da9fea48481219d8592cf4ca0e017c919f0d9387c5a3579ae514f49b8"
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