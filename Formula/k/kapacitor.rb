class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https:github.cominfluxdatakapacitor"
  license "MIT"
  head "https:github.cominfluxdatakapacitor.git", branch: "master"

  stable do
    url "https:github.cominfluxdatakapacitor.git",
        tag:      "v1.7.7",
        revision: "f59b0b1f0c0681f37a7aa62d79600009d2f168c8"

    # TODO: Remove when release uses flux >= 0.195.0 to get following fix for rust >= 1.78
    # Ref: https:github.cominfluxdatafluxcommit68c831c40b396f0274f6a9f97d77707c39970b02
    resource "flux" do
      url "https:github.cominfluxdatafluxarchiverefstagsv0.194.5.tar.gz"
      sha256 "85229c86d307fdecccc7d940902fb83bfbd7cff7a308ace831e2487d36a6a8ca"

      # patch to fix build with rust 1.83, upstream pr ref, https:github.cominfluxdatafluxpull5516
      patch do
        url "https:github.cominfluxdatafluxcommit08b6cb784759242fd1455f1d28e653194745c0c6.patch?full_index=1"
        sha256 "3c40b88897c1bd34c70f277e13320148cbee44b8ac7b8029be6bf4f541965302"
      end

      # go1.22 patch for flux 0.194.5
      patch do
        url "https:raw.githubusercontent.comHomebrewformula-patches4928e7c7ac070ca64e2c62393c1e7ae95db7889fkapacitorflux-0.194.5-go1.22.patch"
        sha256 "3290b34f688edad2dc10a4abd88ea2ee8821cd547ee99325fbbbe4652ad62bea"
      end
    end

    # build patch to upgrade flux so that it can be built with rust 1.72.0+
    # upstream PR ref, https:github.cominfluxdatakapacitorpull2811
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patchesc004d4600a284d62ba74741ffb60f0474403478ekapacitor1.7.7.patch"
      sha256 "c70370136bb4b32112157ce4cc9748a0287a6d9dc92e6651711baa75eb5514be"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "451c6a3aa08d84641cf3dadf1f68d35c52bd7c15d9ca88b2798c2ce77b6b6b45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6567975ba8a72a373a8268866b2aad44e10865dfb91b7debc62ad8d15cee73cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26a545b9888d32bb46390e6038b1e7376158065168f7fe5d5e00633416a24a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "611ab90e163c42434d7c6689e422fb659ad7c56a346fdc55e1040733a3088e38"
    sha256 cellar: :any_skip_relocation, ventura:       "4df541aad47ccb1217f61955e2aacbb8669d1b19959222201828b9c67b43765e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e1405e7b3de7b5d4d93223800c79cd34247718e8837b68e28e1592b7f6a812"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build # for `pkg-config-wrapper`
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https:github.cominfluxdatapkg-configarchiverefstagsv0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
  end

  def install
    if build.stable?
      # Workaround to skip dead_code lint. RUSTFLAGS workarounds didn't work.
      flux_module = "github.cominfluxdataflux"
      flux_version = File.read("go.mod")[#{flux_module} v(\d+(?:\.\d+)+), 1]
      odie "Check if `flux` resource can be removed!" if flux_version.blank? || Version.new(flux_version) >= "0.195"
      (buildpath"vendored_flux").install resource("flux")
      inreplace "vendored_fluxlibfluxflux-coresrclib.rs", "#![allow(\n", "\\0    dead_code,\n"
      (buildpath"go.work").write <<~GOWORK
        go 1.22
        use .
        replace #{flux_module} => .vendored_flux
      GOWORK
    end

    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath"bootstrappkg-config"
    end
    ENV.prepend_path "PATH", buildpath"bootstrap"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdkapacitor"
    system "go", "build", *std_go_args(ldflags:, output: bin"kapacitord"), ".cmdkapacitord"

    inreplace "etckapacitorkapacitor.conf" do |s|
      s.gsub! "varlibkapacitor", "#{var}kapacitor"
      s.gsub! "varlogkapacitor", "#{var}log"
    end

    etc.install "etckapacitorkapacitor.conf"
  end

  def post_install
    (var"kapacitorreplay").mkpath
    (var"kapacitortasks").mkpath
  end

  service do
    run [opt_bin"kapacitord", "-config", etc"kapacitor.conf"]
    keep_alive successful_exit: false
    error_log_path var"logkapacitor.log"
    log_path var"logkapacitor.log"
    working_dir var
  end

  test do
    (testpath"config.toml").write shell_output("#{bin}kapacitord config")

    inreplace testpath"config.toml" do |s|
      s.gsub! "disable-subscriptions = false", "disable-subscriptions = true"
      s.gsub! %r{data_dir = ".*.kapacitor"}, "data_dir = \"#{testpath}kapacitor\""
      s.gsub! %r{.*.kapacitorreplay}, "#{testpath}kapacitorreplay"
      s.gsub! %r{.*.kapacitortasks}, "#{testpath}kapacitortasks"
      s.gsub! %r{.*.kapacitorkapacitor.db}, "#{testpath}kapacitorkapacitor.db"
    end

    http_port = free_port
    ENV["KAPACITOR_URL"] = "http:localhost:#{http_port}"
    ENV["KAPACITOR_HTTP_BIND_ADDRESS"] = ":#{http_port}"
    ENV["KAPACITOR_INFLUXDB_0_ENABLED"] = "false"
    ENV["KAPACITOR_REPORTING_ENABLED"] = "false"

    begin
      pid = spawn "#{bin}kapacitord -config #{testpath}config.toml"
      sleep 20
      shell_output("#{bin}kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end