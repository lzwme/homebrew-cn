class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.15.0.tar.gz"
  sha256 "adcf9dafaf662aa4785c4fc9d2c3dd1165de500bf11f8e3dff57337b1263417c"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad25fb1cdca844589ef2ec8e855b93b5786990f157cc34ee0526c6208a8f057b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bde589aead7008c4895ea7bc86414f6717c92bfbcbb20d14a4e24bedce93336"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b5f699dd45d5837c2c6cb5d2640b13ab291d3a31da21577b067c9ea48b04bb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef01427b155c7f3c257101c16188cab4427bd6f9618bb0244a7f01c9e93506b1"
    sha256 cellar: :any_skip_relocation, ventura:       "9dc1cf178b27790f3d65eee8a3b25b51257a95d1cb8ee3aad05d9e2371488474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c4f5d6318a3de18d946a61d4acd04d6736aa5964cc0c5ee363510ebe699882"
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