class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghproxy.com/https://github.com/influxdata/telegraf/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "baaa35fef9fa7b5382d39f795d4baddbedd43ba8b20386cd5a63d1c5c35ee4c6"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3547713bda239d32f86d2268ea546e23ed28d82056bb8a82b40218ae88329865"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d2795cd6f3f1b8f9aa157a3f5d3bc179595d07f4de5815f582e7d9f673af2b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36bd87bdac15b6ec8a2e6f8c166110cdd27be1152dae0d515f7b8be0bcd72efc"
    sha256 cellar: :any_skip_relocation, sonoma:         "efe2f0da0c521f07659e2be3608a8b927d78709d56cedaa8cb1a33fce1d28625"
    sha256 cellar: :any_skip_relocation, ventura:        "b66b78e7b91044eb82149383645beea7d8483d585dab0230f091288b6a703ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "89400e47aa0963f039ccb497fa79f073bbd791cef719947051e8542b56a5e2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9011857726e12c59705f0142fb4fb105dc3db067f0b0dd2cb8533af19f15fff1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read("#{bin}/telegraf", "config")
  end

  def post_install
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
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end