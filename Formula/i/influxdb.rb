class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https:influxdata.comtime-series-platforminfluxdb"
  # When bumping to 3.x, update license stanza to `license any_of: ["Apache-2.0", "MIT"]`
  # Ref: https:github.cominfluxdatainfluxdbblobmainCargo.toml#L124
  url "https:github.cominfluxdatainfluxdb.git",
      tag:      "v2.7.8",
      revision: "18c989726c3b879902a1d609c0eda17ed61c34d2"
  license "MIT"
  head "https:github.cominfluxdatainfluxdb.git", branch: "main-2.x"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple majorminor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c7fcb3d126e80a11cf8e954dd4aaeae900d38135bcb8cc6e414f95dfe83218a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b177adeed8d670687122fe4b7cc0d74ba953bdb05314c89dba2a2c3f7b0c1949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c515dcb4dbcc073b2ef8f1678988ed623f7d4fe750b968b53340043195763bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "af37bc657c3cc788072b5aaae55ffa704b3ebe9a1e2f10b40d398c29940c8ac4"
    sha256 cellar: :any_skip_relocation, ventura:        "5f09f0c1b6b887a79e1403ed3a747ef19877bf6273321e69d52ae4d778957589"
    sha256 cellar: :any_skip_relocation, monterey:       "c2d71c3bb40719ce5ba5b72a1874a8e06f28a8490452f15203230e25a05f04ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c887f19494e36c2ed8b78b869104b9256674296615f542da6dd4b6d663674da2"
  end

  depends_on "breezy" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https:github.cominfluxdatapkg-configarchiverefstagsv0.2.11.tar.gz"
    sha256 "52b22c151163dfb051fd44e7d103fc4cde6ae8ff852ffc13adeef19d21c36682"

    livecheck do
      url "https:raw.githubusercontent.cominfluxdatainfluxdbv#{LATEST_VERSION}go.mod"
      regex(pkg-config\s+v?(\d+(?:\.\d+)+)i)
    end
  end

  # NOTE: The versionURL here is specified in scriptsfetch-ui-assets.sh in influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "ui-assets" do
    url "https:github.cominfluxdatauireleasesdownloadOSS-2.7.8build.tar.gz"
    sha256 "28ace1df37b7860b011e5c1b8c74830b0ec584d2f86c24e58a7c855c168f58a8"

    livecheck do
      url "https:raw.githubusercontent.cominfluxdatainfluxdbv#{LATEST_VERSION}scriptsfetch-ui-assets.sh"
      regex(UI_RELEASE=["']?OSS[._-]v?(\d+(?:\.\d+)+)["']?$i)
    end
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath"bootstrappkg-config")
    end
    ENV.prepend_path "PATH", buildpath"bootstrap"

    # Extract pre-build UI resources to the location expected by go-bindata.
    resource("ui-assets").stage(buildpath"staticdatabuild")
    # Embed UI files into the Go source code.
    system "make", "generate-web-assets"

    # Build the server.
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin"influxd", ldflags:),
           "-tags", "assets,sqlite_foreign_keys,sqlite_json", ".cmdinfluxd"

    data = var"libinfluxdb2"
    data.mkpath

    # Generate default config file.
    config = buildpath"config.yml"
    config.write Utils.safe_popen_read(bin"influxd", "print-config",
                                       "--bolt-path=#{data}influxdb.bolt",
                                       "--engine-path=#{data}engine")
    (etc"influxdb2").install config

    # Create directory for DB stdout+stderr logs.
    (var"loginfluxdb2").mkpath
  end

  def caveats
    <<~EOS
      This formula does not contain command-line interface; to install it, run:
        brew install influxdb-cli
    EOS
  end

  service do
    run opt_bin"influxd"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"loginfluxdb2influxd_output.log"
    error_log_path var"loginfluxdb2influxd_output.log"
    environment_variables INFLUXD_CONFIG_PATH: etc"influxdb2config.yml"
  end

  test do
    influxd_port = free_port
    influx_host = "http:localhost:#{influxd_port}"
    ENV["INFLUX_HOST"] = influx_host

    influxd = fork do
      exec "#{bin}influxd", "--bolt-path=#{testpath}influxd.bolt",
                             "--engine-path=#{testpath}engine",
                             "--http-bind-address=:#{influxd_port}",
                             "--log-level=error"
    end
    sleep 30

    # Check that the server has properly bundled UI assets and serves them as HTML.
    curl_output = shell_output("curl --silent --head #{influx_host}")
    assert_match "200 OK", curl_output
    assert_match "texthtml", curl_output
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end