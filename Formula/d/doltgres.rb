class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.55.4.tar.gz"
  sha256 "3c5be9b4581d578ce1c9cfccf0bf86881ca4ab382e8141a429b55eed4e0edb78"
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
    sha256 cellar: :any,                 arm64_tahoe:   "1774178ec009b75fe0204bb47d5c60ab983ac0a22c0a15b4f1e7d38fa380f3e9"
    sha256 cellar: :any,                 arm64_sequoia: "42b872100bce583c6108893b92257e0ffa72f302aadf06a2100ab30355664375"
    sha256 cellar: :any,                 arm64_sonoma:  "0e063390def255292d873ba37c1f8b3f3e36124b134cbdf229afe931dab04f0a"
    sha256 cellar: :any,                 sonoma:        "e8a3d7587941a463add0240dda27013fa01ccc51cc3d2dda8f6681911a8383d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec81a9f294500942366146923f3271deb9dd286a39aa6cec882e271902750a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db4e30f16617c2eb09fc9b6a98be778ecff142eb0b9a8686a1c60800e45b30e"
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