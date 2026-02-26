class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.8.2",
      revision: "fd553065392840604fd65abe03556ad44bd1fc91"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00162adb81c94901660e4af99e4ee887be9561aea34fe9a501ad6d97be3a1177"
    sha256 cellar: :any,                 arm64_sequoia: "1c13d58ae65496de21f2c7e7f0d9d920f591f7119ca00a8e99f7622e4fb5229b"
    sha256 cellar: :any,                 arm64_sonoma:  "dc7818ddecaf48d6f51ae274eca4e026b0c6e6343949593586cb1ed8abc3a042"
    sha256 cellar: :any,                 sonoma:        "7d970bdd263f4e9067b3999b4a0ce154e09e3b8b53a3a8ab47f9b90c36865603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0500b5b8f6b3c5fcfffaf9637cf88477fb204fb74ce510c11ed2ca8935c6d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675b6ee14aaa82d0bbd298a8a3cfc0158a54afc3ce443e7b41b632a7cafb5d63"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  uses_from_macos "bzip2"

  on_linux do
    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    python3 = which("python3.14")
    ENV["PYO3_PYTHON"] = python3
    ENV["PYTHON_SYS_EXECUTABLE"] = python3

    # Avoid upstream's default of Haswell and instead let superenv set this
    inreplace ".cargo/config.toml", '"-C", "target-cpu=haswell",', ""

    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

    system "cargo", "install", *std_cargo_args(path: "influxdb3")
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
    sleep 5 if OS.mac? && Hardware::CPU.intel?

    curl_output = shell_output("curl --silent --head #{host}")
    assert_match "401 Unauthorized", curl_output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end