class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.54.6.tar.gz"
  sha256 "7422369242bd51fa3f11a9f9cf50255ed8f985e11dba7f4838b4dd817f4916b0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "03e6e5f475223c6ee8c9873978bc953f4713e65882c6d05d7814407e4770c000"
    sha256 cellar: :any,                 arm64_sequoia: "d928c883f167a04dad1ec8fd59d11d782270d12f570a63a9fbf76fa7cdb4e511"
    sha256 cellar: :any,                 arm64_sonoma:  "f1e76c5ebfb5ccfd8a4d1968a5870082bed99f7f1685fbb65c2c60eb13fda7bc"
    sha256 cellar: :any,                 sonoma:        "c4b21da60dad0fd92b76bfdc5eff6e0d4db5ddcb7152a270ed24511175de2869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb80684cca0919c436e725a976f214e66bbec14b3ca59f22d22733183eabd930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "343aefe432259a2375132f1e15faa5d17f6c9cac3558d2ddcbeaf6f8c2bf92bc"
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

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end