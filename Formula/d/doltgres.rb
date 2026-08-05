class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.57.3.tar.gz"
  sha256 "b062fafdba54b72b0433bd46952623ef65adde153bd53a2faad2e525ea977b80"
  license "Apache-2.0"
  head "https://github.com/dolthub/doltgresql.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "094f6df8c914ed1ee5fefda68d9bbd60eb16e21d73bceb3481660e5d0af2f61e"
    sha256 cellar: :any, arm64_sequoia: "5eece2c3f263c767774fc7e700c8ad7bb125b86e2f2d45c8c14e084f1518f7f4"
    sha256 cellar: :any, arm64_sonoma:  "32de0e742e2e6e360e7e3415c43745f87d877aa3b59f9aceff06a56aadc9289b"
    sha256 cellar: :any, sonoma:        "237294eaa1aeb8dd23779e8a6edeb4a521b566a66f78683152e071a1e8e2ac3c"
    sha256 cellar: :any, arm64_linux:   "106f4eb8cf7ae595c7b1ec206397b657b6c19b6eb6a1a9f83ff79e52c099ce2a"
    sha256 cellar: :any, x86_64_linux:  "8f708b747db7a0e06cf1482fd9a4f2ff15c0ec5206a8a16d9d5aa7697fb1b05a"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args, "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      log_level: debug

      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    YAML

    spawn bin/"doltgres", "--config", testpath/"config.yaml"
    sleep 5

    psql = formula_opt_bin("libpq")/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end