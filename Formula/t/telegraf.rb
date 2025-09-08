class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.35.4.tar.gz"
  sha256 "8f65d493ec0597369cea6fec8a9dfef2fc8833a44cc9291f13397481635f2a6d"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22faf15241c5bdc77af398a4b6feb7183ab9c96e246978b07a4b602fa0b87ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "486e6428641d76fd30562bc1183b07dab0cd2c45f1709cc585b037b7a336e368"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4320924da539b6abd7cc3fe06055f98d5d2f23600a665ed5caf71c5281a5bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "87932396ddc123a216b95631b570b401f3641ef1d72efe9f95e26d90f8bbca60"
    sha256 cellar: :any_skip_relocation, ventura:       "c1e21d8d864d44b770ed1126d4a888e7c85da68c07fb3f5d1c130e7663978e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff2c5639d6f48ee1cf9dd564c1f228f65d8f7e8ada0c39f6767044d654af8f91"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"

    (buildpath/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
    etc.install "telegraf.conf"
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end