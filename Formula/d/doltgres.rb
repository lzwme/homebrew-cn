class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.54.4.tar.gz"
  sha256 "11f8986bca126743fce5b085a2dc75319cf92c4ee2ea3d4a70f6c1d2cdcb52d9"
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
    sha256 cellar: :any,                 arm64_tahoe:   "fd91263c7611d67eb7d5a962d96ef82c95432b5aecc168e2c479c60864713e01"
    sha256 cellar: :any,                 arm64_sequoia: "5a2453cb653e2e3598397225dfe296f114d10e07776e7aa1a22ce7edb179487d"
    sha256 cellar: :any,                 arm64_sonoma:  "f65d2d92e48278fef31dc29db73065da7bc3bf76d1fe12b81cda66c482b7163e"
    sha256 cellar: :any,                 sonoma:        "4f172409de0a79f77e907cad01cc9f7831f3c25b7fa80046fcd3f5858ed29370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4e097a53e7e1d97eb65fadad973cbd202610c254278826afadba0599d22b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b44cc8bdfaee548a7d180d803079718e415b9be6aa18bbb7cb41ef27b64159"
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