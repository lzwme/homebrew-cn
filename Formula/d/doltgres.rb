class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.11.1.tar.gz"
  sha256 "f76b74dd743d3a32dd8aba69a060e1f3782021d2b9fc00949cf174b6cafbc559"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9836172871e6206cf2560ba20098acfa40cbaa8062da94fd8951413c3c65bced"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1111284c36af14768e6d56f24349da00682688de32124c2f66074361b564088f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b709fb75f1b92071ae0e5f1968a04ace6eeecc381cf7dea2e97a8a71f7a7f30"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9d9ff6e96a5caafdd31ca55a98d2f2d7c545d39337d2cfaab76f79dc85a665a"
    sha256 cellar: :any_skip_relocation, ventura:        "89f43e08071eea95a86295c94b44c2f71ff8a8a1fe9b6e6afa59074234f8a1e5"
    sha256 cellar: :any_skip_relocation, monterey:       "ab84c53a7d4a1364420af8856b9788bc00f6a71476317c3e0b956c1dc7b0a40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87cabd4acaf63f750bc72ba98d9b54c2ea2d2b0de98d8d4d54d4ccaeaf59b7ce"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system ".postgresparserbuild.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddoltgres"
  end

  test do
    port = free_port

    (testpath"config.yaml").write <<~EOS
      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      user:
        name: "doltgres"
        password: "password"

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    EOS

    fork do
      exec bin"doltgres", "--config", testpath"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin"psql"
    output = shell_output("#{psql} -h 127.0.0.1 -p #{port} -U doltgres -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n doltgres\n(1 row)", output
  end
end