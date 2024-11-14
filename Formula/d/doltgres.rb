class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.14.1.tar.gz"
  sha256 "049603a7d08508b218f22e2067c4d5f18f890a211df393d3aefa7c4324f20052"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c96f61a8fb2a975fbc9bb0408958e6f137b55b0f21245a1885e11959ee53a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41972a30a054113c5a282fef2369f4b6d4da434d0a4cbc0191f8e062fdc1451"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "461e80535fef83f65ce5e3b8323372f9b33a87e6da6f457a3bad0b7ec755b4ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a104d53604692caf92747c0476d9a1fa1d3768ee228609595b3cc9148df27af"
    sha256 cellar: :any_skip_relocation, ventura:       "511f467903a6b8c0bef736e2df4d886fc5419a7f5874cf66dd48dbb1bba93ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55a0e71ab534d6500b49f928b242f575762eedb328e0caeee748206df5d905b"
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