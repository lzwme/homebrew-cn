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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16ab41c6f874c7b1f4a3270f330737ab97bca896bd0ebc16959b98ca9d4508d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d883510e1b2a7ce917bcda970363dcfe5fb8d7b5470ff139c5ba4cb8cfbed8d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feb8a53d3796b3a3f6db169cfcfbff22ea1f4640c6dfa4bcef7279229e898913"
    sha256 cellar: :any_skip_relocation, sonoma:        "22571e63d45311ce6b79114d1ffbeba4d2afc9c04e15200ad799dae9078bdd54"
    sha256 cellar: :any_skip_relocation, ventura:       "575068844d81e6c2623d995aaf2f3891e0d19ba3ad555db6575b76bb2cb56274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b659d515984209fb912df2e58ab96f2ac9b93240f89885f85e4c6d57ece1e30"
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

  # update flux dep to fix rust build issue
  # upstream bug report, https:github.cominfluxdatainfluxdbissues25440
  # upstream rust 1.83 build patch, https:github.cominfluxdatafluxpull5516
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesa2f5c7e20f69eabde99098e6480d2b29faaf2638influxdb%4011.11.8-rust.patch"
    sha256 "f24a5021b72a3ebd9b7234c35f033fa0f5d5f10377257af09dcfdbd84fcf5ed4"
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