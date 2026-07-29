class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "b6079caa695a7c5e9784b7b98f3c775c8b622677d8302796914f110e9f1cd855"
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
    sha256 cellar: :any, arm64_tahoe:   "c861e6f51af7e9c95b0c3f58c5716d14ffdc1c1829b2c366d170eed19389be5c"
    sha256 cellar: :any, arm64_sequoia: "86edf426a0307f435bea57406445345f2b59065af48d2cc3d2f24e71b73998bb"
    sha256 cellar: :any, arm64_sonoma:  "245f7be9a05f5d7e43559ca82a3632861ca954f0b41e390e631978b5751ae8c8"
    sha256 cellar: :any, sonoma:        "131abc56ec263b8828d34a2fa9317e154f48d5b9a1632f61951623f7110eebc8"
    sha256 cellar: :any, arm64_linux:   "96ed1c338d66f7b90f716e4648b7bf58239f1e2c91c1e1fc33f31e75be0137f9"
    sha256 cellar: :any, x86_64_linux:  "0bd391c99cf961d8fd91020661ee805c4201e7a422aa49307ebcc46ba5f477db"
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