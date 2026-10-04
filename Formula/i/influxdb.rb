class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.12.0",
      revision: "3ba97c65f1ee4e1f127a8266517d4d2083b7ea39"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_OSS_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e082e82371c5912696947fc17bfea2833b2ebed9a4b6c160c24f86bd4534148"
    sha256 cellar: :any, arm64_tahoe:       "d541ecb38d7ce7b2b09f425d81449147e09a0ed064b6173bb1128a479746f454"
    sha256 cellar: :any, arm64_sequoia:     "b5986abca6dfe93c19ae6373e537dd49ad5aebe0db8877988e86a26527677d48"
    sha256 cellar: :any, arm64_linux:       "2418ec169b10867d8a51d9fc7f43ae346dd9493fd720ed9d766714917896f1b5"
    sha256 cellar: :any, x86_64_linux:      "e13c678707bb8964c33dc335197f327edf0eb600f2c9840c25bcfd2244271a2e"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  uses_from_macos "bzip2"

  def install
    ENV["PYO3_PYTHON"] = python3
    ENV["PYTHON_SYS_EXECUTABLE"] = python3

    # Remove local development overrides which isn't used in upstream CI
    rm ".cargo/config.toml"

    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

    system "cargo", "install", *std_cargo_args(path: "influxdb3")
  end

  service do
    run [
      opt_bin/"influxdb3",
      "serve",
      "--node-id", "default",
      "--object-store", "file",
      "--data-dir", var/"lib/influxdb"
    ]
    keep_alive true
    working_dir var
    log_path var/"log/influxdb/influxdb3.log"
    error_log_path var/"log/influxdb/influxdb3.log"
  end

  test do
    port = free_port
    host = "http://localhost:#{port}"
    pid = spawn bin/"influxdb3", "serve",
                          "--node-id", "node1",
                          "--object-store", "file",
                          "--data-dir", testpath/"influxdb_data",
                          "--http-bind", "0.0.0.0:#{port}"

    sleep 5

    curl_output = shell_output("curl --silent --head #{host}")
    assert_match "401 Unauthorized", curl_output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end