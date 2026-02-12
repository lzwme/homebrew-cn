class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "6a91d12041f33005582f834a040cb553cc958014b0d2d30123ead5c11d810ae9"
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
    sha256 cellar: :any,                 arm64_tahoe:   "f270b527350224453a06244c598046e64f9aa468f1913c8338ee0e24391e4b46"
    sha256 cellar: :any,                 arm64_sequoia: "aae07937833920a9c988c468735869dc993152d34d978cc2889e9d583ad9d535"
    sha256 cellar: :any,                 arm64_sonoma:  "6a7046e031a5f35e28b05932db576660f2a8e6f60282b225db3382c6a6c0811e"
    sha256 cellar: :any,                 sonoma:        "ae3a8e7b45f72ec17a41d679477c4e8a4884e1f11fdd432d887cfda91d3ed829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c36594dc31e8153c3c109f0e1801e1e29fde2b585720e3699d314d104c14b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ae28f50cda526b154911bb491fa590735a031abf4ba7fac1ae13801fcf09126"
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