class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.53.3.tar.gz"
  sha256 "921fc15552927b6a7c2e9dadf0e9ba86177dadce04d3f916094aa9f546cfacae"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8c355a714be170eca04bbc2eaa2bbc7f6ead05ee512a93431b1f256b97e88964"
    sha256 cellar: :any,                 arm64_sequoia: "0f6c9d9ad43fb26c3a54f58976fd16b99d7b8e2bc7aeb6548c9e6c85b8de257d"
    sha256 cellar: :any,                 arm64_sonoma:  "252527a5316e017eee5d47a1e3b3f0e3ebd00e336a1535927f2032e270e4d836"
    sha256 cellar: :any,                 sonoma:        "2c2229d1631008da4a42f62ceef2b54ccfa1c05cf1faab67fb8afea2bca8f75e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ef3540ab62cd0703a2949140207630ff73ed2b0b50a24262a8bcbaae6f844b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99fb321bbeb2a4d05baa1ea3c4dd33a9c3aa7dba54fee0db76c8c541bd7c08d0"
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