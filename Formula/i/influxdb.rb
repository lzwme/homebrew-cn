class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https:influxdata.comtime-series-platforminfluxdb"
  # When bumping to 3.x, update license stanza to `license any_of: ["Apache-2.0", "MIT"]`
  # Ref: https:github.cominfluxdatainfluxdbblobmainCargo.toml#L124
  url "https:github.cominfluxdatainfluxdb.git",
      tag:      "v2.7.7",
      revision: "e9e0f744fa892ce2f7936ff8f2bcbf286938c6a0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d24266a41b4231d0dbb1b7dbf055c9e5f8f4ea3fe28090248241917e1202153"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b1038febc48cf7c5da8f898b38b9ac3f878404cb9ccabd1617946e778cc0040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8ee05bdb1a6d7374877b4efd0f67c361c4505b11d25f1b432233681e28abc25"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d09d5f7a7bf1405224a89c4daeb9e9494e7752bd06eb36e9420a5d50141963a"
    sha256 cellar: :any_skip_relocation, ventura:        "6c9dd71d0a9322ab1ae652a3a9071ac10b539b952aee04df179eb8eaf87c7418"
    sha256 cellar: :any_skip_relocation, monterey:       "4e5208e5c2bb9e84599eb49a5627227cf1cebc1763de7ef1784e1c4617febd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff6d1c1c609da92bba7d207d9a0e742e6b026894fe592a6897a41bbc17aab86"
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
    url "https:github.cominfluxdatauireleasesdownloadOSS-v2.7.1build.tar.gz"
    sha256 "d24e7d48abedf6916ddd649de4f4544e16df6dcb6dd9162d6b16b1a322c80a6f"

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