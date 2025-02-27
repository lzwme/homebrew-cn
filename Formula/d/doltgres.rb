class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.17.1.tar.gz"
  sha256 "e3f229f5ccc907f4dcd66f8d62ac4ea6c50cb095c0e9e02d581812b68c9a37c2"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be8640680bac464c218aec0693c178d3fe9394393e32af652463e0b59a56ffd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c7fdbb30bcd60cc9c571ef4d890f91fa64e17b57fda67dc46211838b69bd9fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d11fea914fdc1f5dbcba4b18e883a37ffdb448355bd39541c3d888657432cfc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4070e353770650e670af352ca32c340b255a36de5d8f68efe0720eefea89b5d5"
    sha256 cellar: :any_skip_relocation, ventura:       "594a07bc191068eec42a1bcd85273273613d63366f30dd040f9630fd16c24173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b31f891e5f0174ece5d5cf3b48f2651a55bf4b1561908367c04eb904511aa5"
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