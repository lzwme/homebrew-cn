class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://ghfast.top/https://github.com/dolthub/doltgresql/archive/refs/tags/v0.54.7.tar.gz"
  sha256 "41b4401599501c93e9282cb898bbf5228c0214b181423ea8e6b7c00d628d2326"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a6027b9196bc79d6275db5fc658ecd1f3cd54d572de9ca6ab3ae4ee3e6ee662f"
    sha256 cellar: :any,                 arm64_sequoia: "6f6574540af808a12b7fb29cdeb0d457a0b7da84297aca82997c77e9a36745e0"
    sha256 cellar: :any,                 arm64_sonoma:  "15368423a20fc03ceace12f4f95252c680eeb0aa114e201b8acdc651060dfc12"
    sha256 cellar: :any,                 sonoma:        "c83ab232ecd3c5cefa45dde550b24e0b5dd527d7fe7dda7c1c604415e788fab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5139159f9018fbce2557dc0e4a4b0e9cc051a8357b2e5ee99f0f8c298e9a139c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15667aca9450d266c6380b859cc8843e0a90ed7cddd80a05498174c5ab67671b"
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