class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.7.5.tar.gz"
  sha256 "2aa186b790735cb877fa623bc9b74a69dc5eac548221227184e8681fe3837462"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37ecb81d50be272d1d5171d224e573bee0be8cb9242b963718d47e71080b9cf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0651306393b58c17d08a080aee788e9e2f11d5fb976c8105279bf8c6db437236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "289673c116d33a9669b93cce25a5abbbd47a18ec56a6b93a342a06aa923c3942"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2176eed8781bd46217e94accbf1104f54a4dc5d4754f1aa2205d9e5ccaa9e6b"
    sha256 cellar: :any_skip_relocation, ventura:        "7a35895ab914d195f91ace397f20773bfafcb51b507055ea1358494abedd3539"
    sha256 cellar: :any_skip_relocation, monterey:       "ad553e69853cfe9c00d83ff6e69b7b400ad41cd6ebe04f038c1ef85200ed1ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa1d23470f4dca39c0ac58b3ec53bb0eec96dadc267024b67a2771147c68f9f"
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
    assert_match "database() \n------------\n doltgres\n(1 row)", output
  end
end