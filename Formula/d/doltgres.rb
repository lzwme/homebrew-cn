class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.7.4.tar.gz"
  sha256 "26aa819db16975a9ca5b4560855949f435087f8d36cf50a69c383320e6212a91"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b753f3a728a83818b4c9a4cb52c8808ade7f6169c34d9c2c525117f080e1a85d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b94b31131436cb4f7d71c162d80fb97f83ac5e3a07c51b8c98cfbeb7a918b755"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e94649dade3562453d93e268934719b37d0d7a9629ff6c8a412fc97e9761ffb"
    sha256 cellar: :any_skip_relocation, sonoma:         "10040b48f2de6bc5b80efb05d747089c8441fad54926279961675b6b7fcabb95"
    sha256 cellar: :any_skip_relocation, ventura:        "7d480ac2831526fd5090365ddc1ad6496e8240a6dbae826455d6d3215b6c095d"
    sha256 cellar: :any_skip_relocation, monterey:       "154cc5484ab4661c2a28dec58d5d8019cd559a3b72fe9543868d08a7f837af27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962105ce5424342940f4c4684d9145c3edc6ebb0a92ec4b98b6c064fec3193ec"
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