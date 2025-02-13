class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.17.0.tar.gz"
  sha256 "27d597099a640ef8deb069ba1cd67f0fcc8bd4989f75a8446a0b2f9171a4676f"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48dad9326f83273d51cb56b777f7b6293e148d4f0a78afc162187fce9b60c455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4c8d934be57acb30880313954a977f518af9c252bbfcb49bef1f2ec5bd65a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c06486489e16b270c09845aa4132fb7f505ee9bb67e11671681161f4fd4a2e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0efa4f0ff5d210f64c3275988942fea91cf712a8ba699f94c79df52ab1c1128"
    sha256 cellar: :any_skip_relocation, ventura:       "9f6c1fb482a089047b97bcd3425f816f798ddb514c41e8a6c602664e4afa47c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa58ba6f655369b92af413c89a2ebcbd87c43e3d1c5a202979d0216082feb241"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system ".postgresparserbuild.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddoltgres"
  end

  test do
    port = free_port

    (testpath"config.yaml").write <<~YAML
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
      exec bin"doltgres", "--config", testpath"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin"psql"
    connection_string = "postgresql:postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end