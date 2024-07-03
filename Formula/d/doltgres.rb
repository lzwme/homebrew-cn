class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.10.0.tar.gz"
  sha256 "2b3bf7803658b098f80a4fbf260071b5d0e122076964a7ae014cfd1fa9e7444f"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b36d606185e73eb85272418d7f84ce68f38e85c927777878804e726fe38d1563"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8375849ad426a075e8fd0fc70ca546c605a6159459a08dd0664d3d9da751c0e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403f4df8959a11de27570c8dfcb22168d71ceab86da9dc987b2f8c2d1a2a30ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "9343d07e1871ff9d80649671c2e99d768c97ed1ea388935d9178f36878dc4452"
    sha256 cellar: :any_skip_relocation, ventura:        "d97ea777a0b6bec39c895d5d7e54ed9c23cb621cbd19cb7740c12045bed4435b"
    sha256 cellar: :any_skip_relocation, monterey:       "f3dbb9ebea1eb7bd12be36f6d49eca0725c13d3aea1d8f8024a25eaba45f0e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933bb88ab78bb6d0662e75370e98ebe753b489ca49cf3d7c83f09ce91d8a4256"
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