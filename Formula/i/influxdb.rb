class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https:influxdata.comtime-series-platforminfluxdb"
  # When bumping to 3.x, update license stanza to `license any_of: ["Apache-2.0", "MIT"]`
  # Ref: https:github.cominfluxdatainfluxdbblobmainCargo.toml#L124
  url "https:github.cominfluxdatainfluxdb.git",
      tag:      "v2.7.9",
      revision: "91c1a5d3d8f99507098d579ad4fced2fb67ab3d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64d8086197700bb793e220adebf4ed228eac7d3392532149fb4cd46e416ada3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22e6bfd755c34f2c9ba648ac3e9896d52a694306e4ffecc81d971408d327748d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b472624097130ed69e34b8224a266a3f1b44a16c3fb89731ef3f99d183c7b075"
    sha256 cellar: :any_skip_relocation, sonoma:         "696439760c290a1835d54bfe502d00c9524ca7377f5309096cb5c5ea289dbddd"
    sha256 cellar: :any_skip_relocation, ventura:        "9a9c5d95fb03692ff11c6e21c291dd9617bfbd8f994e56694ad5fdc365ac9acb"
    sha256 cellar: :any_skip_relocation, monterey:       "8ebd66860564b74a61fba83900f78f8195c71f8af3de2c262cc3a8861f7d8d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020c6867fa6eacbf85a833cc5749104a13c93434f87c6282e2e9ff0644537c20"
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