class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fa463d4b4a3a950d32f6fe7eb2853800ce7027d5d3b830e01bd428c1daa8c440"
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
    sha256 cellar: :any, arm64_tahoe:   "7a489c7e6b4dd68807ba7c035cff7cb4a405d800ba117b2217e6db245e476ca2"
    sha256 cellar: :any, arm64_sequoia: "67eaecaa140fe2881fe22ce98fd961c72da7dbd617a7322c86c7885e64d74c90"
    sha256 cellar: :any, arm64_sonoma:  "49968d95f81e13551520f7a5676ef7e77232d5beb093841a592c733cf746249f"
    sha256 cellar: :any, sonoma:        "626d5aa828b6613bb7d8e8039049b78d7ec41ba5f4be53002c2d952fc7b9a004"
    sha256 cellar: :any, arm64_linux:   "7e52d8fa8b4fbb958c01743620e96790e0a73bdb8368c67b74aa8beca1c19497"
    sha256 cellar: :any, x86_64_linux:  "9bdd341bc13fb9de3b49be114da08798f2c81a23eefe6705a2f033f247ba9fcc"
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