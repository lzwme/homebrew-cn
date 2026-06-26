class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.5.tar.gz"
  sha256 "0951083a0412baf7116274bfb91930e8c8930ddceae2a415895976df052c9156"
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
    sha256 cellar: :any, arm64_tahoe:   "56e494f03820bb23f0cb15e01e40e8116f427cfd26de6267ca7bd089bc391064"
    sha256 cellar: :any, arm64_sequoia: "6aef2f7f415e2c6940b35e0f04c3a96c6b05898e7d7e8ddeed44ef8180aa8eed"
    sha256 cellar: :any, arm64_sonoma:  "e8ac536fa318a0aaabced5d76870bf16f3748b603c798a619cf937b1f31599e9"
    sha256 cellar: :any, sonoma:        "655f18b7ef4c3ed7f35990970f86d91877f0457d59002665caa37c14f9c7bcbe"
    sha256 cellar: :any, arm64_linux:   "1b2ca5fb1fb5588ff9eb14c965ed860f30d0b42fb78ee45c2e6682b7ea4e917b"
    sha256 cellar: :any, x86_64_linux:  "426e4375cc1ba3fc9377e4cbea3f00fd54c1773c152a1f70e03ef3c21ce47628"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
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