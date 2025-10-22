class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "bbf1ff269da3c55101d171fedae8f74b20a00b3e33823ac9eddbe248bf4fc76b"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e1e963034b8f1a9133a29c7eee05827a543320f33655c7e1be457b1ce8b9082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f98285790a41e369936e399f19fed4ad6a7320a19e7176134be31ec353e11f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb7ed4cf974db5ac9868829d14c1a6d4a0e47029a9f581d32c805c7193aba68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7711a98448b83fa81b7dcb16ade04c9dda2e0a17da513cfa69aae6c1b9a288d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a48b84dd3f801930313ae8121d5f4d132b3e14861c9ebcfc3bc35d2f0bc8a019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43cd02ad6212cb80c56d4c7cdd9b91a71c179a48cf327d60e79fd02c6aa39b08"
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
    environment_variables HOME: HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end