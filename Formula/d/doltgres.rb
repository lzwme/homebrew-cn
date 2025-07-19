class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "2ba8de8b425f6f808a5d02e33d7ec8cf2ef8277d2c2cbad81b6cc5316f1df5b2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09d1e931be121175e59433f355052d972d2ff5284343c63a28fbb32bd0e55c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed15ab83850ebef8efaff7c602c9c2cb0e0c4f5de9edc39ba69e8e17344f81c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c765932331d0cc5e5fbf03de2e50c842beda6bf444f7d1e59950eecec1bcdab"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd5b4a2202d53dbd0a236675a2f51b5de3f6a46fa8409124a7423fde2ab548be"
    sha256 cellar: :any_skip_relocation, ventura:       "db65ac85ec17325b4651e8e10cd6a21f2c5c688939a737a342afc340c9a1fba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6300317366f9ea03a686c67bce1320d2558e27513b2e9fa4720c038d005bb962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904d5919ac10096e4614d4add09b784a0eedfb48632b7fdf8f5f1c0f9a25863f"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
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