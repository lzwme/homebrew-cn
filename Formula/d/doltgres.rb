class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "1c80cabe787effd9967f027ea0993d31a876afb355e469fff22cb99ea5237a68"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a1509377b7bce9458aff3689f5fe4c97ea402368e5eac035c7217886dadc4463"
    sha256 cellar: :any,                 arm64_sequoia: "f28b7cb09743fdbfd9e3f0d2e1ef59c8b0f7dff48e3d51636ef015205d051e4a"
    sha256 cellar: :any,                 arm64_sonoma:  "192e929de3bd5141ec8fe946e66f84b29d8c6309c3539da3b84ce6a65db38979"
    sha256 cellar: :any,                 sonoma:        "75d74c770ae6a2e95c39c02ceb16506d391bf745fa4b431d22445f43c94fa91f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "138b86881625d4e5fdc809022a97670489e72d917c0ad52dd371d0a7ab04fd7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c2a4bc2a5911c8f3dec50c70794cb2b81af7dd5e680ccf7c66e4fd3fd27907"
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

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end