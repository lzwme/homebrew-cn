class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https:influxdata.comtime-series-platforminfluxdb"
  url "https:github.cominfluxdatainfluxdbarchiverefstagsv1.11.8.tar.gz"
  sha256 "c53e9390ca3c513c508aafc7b91d169fb5200ba741ac9756e59b2f674ae53738"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(1(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee91f95146a964f1edff2713db95d556cdce850c66b8fb1a8be2e63f592ee67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a804285e662148a707e4c67568f743fa6b53962b7c71d0b6a16101886ca056d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fce2ab4adcb4dd5f9616c59be6dc96245ead7f6f8390dd8518ef03423f7f1453"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1294502e77f813839a9f087fd8e08746a853572b58ee961c84f40abaa77ade5"
    sha256 cellar: :any_skip_relocation, ventura:       "a5fc120ab0089ce9c3bb4459efc10b38688a4f5a5241bada4ed38bc39a81d888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10a03c0d30b7801e40f66e43d7cfd3aa877759c87a58412b230b6809105f001"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs
  # to be upgraded too.
  resource "pkg-config-wrapper" do
    url "https:github.cominfluxdatapkg-configarchiverefstagsv0.2.11.tar.gz"
    sha256 "52b22c151163dfb051fd44e7d103fc4cde6ae8ff852ffc13adeef19d21c36682"
  end

  # update flux dep, upstream bug report, https:github.cominfluxdatainfluxdbissues25440
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches984eb256ccb68fe9ee3b3e0f88f7991b0dd55ccbinfluxdb@11.11.7.patch"
    sha256 "4c6ac695f2302ca320db58f3906f346fa48fbd3706964a8be39c5a3da6080256"
  end

  def install
    # Set up the influxdata pkg-config wrapper
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath"bootstrappkg-config")
    end
    ENV.prepend_path "PATH", buildpath"bootstrap"

    ldflags = "-s -w -X main.version=#{version}"

    %w[influxd influx influx_tools influx_inspect].each do |f|
      system "go", "build", *std_go_args(output: binf, ldflags:), ".cmd#{f}"
    end

    etc.install "etcconfig.sample.toml" => "influxdb.conf"
    inreplace etc"influxdb.conf" do |s|
      s.gsub! "varlibinfluxdbdata", "#{var}influxdbdata"
      s.gsub! "varlibinfluxdbmeta", "#{var}influxdbmeta"
      s.gsub! "varlibinfluxdbwal", "#{var}influxdbwal"
    end

    (var"influxdbdata").mkpath
    (var"influxdbmeta").mkpath
    (var"influxdbwal").mkpath
  end

  service do
    run [opt_bin"influxd", "-config", HOMEBREW_PREFIX"etcinfluxdb.conf"]
    keep_alive true
    working_dir var
    log_path var"loginfluxdb.log"
    error_log_path var"loginfluxdb.log"
  end

  test do
    (testpath"config.toml").write shell_output("#{bin}influxd config")
    inreplace testpath"config.toml" do |s|
      s.gsub! %r{.*.influxdbdata}, "#{testpath}influxdbdata"
      s.gsub! %r{.*.influxdbmeta}, "#{testpath}influxdbmeta"
      s.gsub! %r{.*.influxdbwal}, "#{testpath}influxdbwal"
    end

    begin
      pid = spawn "#{bin}influxd -config #{testpath}config.toml"
      sleep 6
      output = shell_output("curl -Is localhost:8086ping")
      assert_match "X-Influxdb-Version:", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end