class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.6.8.tar.gz"
  sha256 "5bfc56cd26beb736fc72f6934d69748602b69101ece7412ffc2f8cc579932021"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9379a57b1618ec82f8dbb107dc8be3a96703f78b8a50d6f7790f7ee37907a2c"
    sha256 cellar: :any,                 arm64_sequoia: "21e6e365ecfdb3813a16591339c88cd315522a1739b57cf4b489c80ea0cd41bf"
    sha256 cellar: :any,                 arm64_sonoma:  "a803ea4a686b5c5a08a91dc6ae1d7bed983aff7c52abe49e262017d3c54ddc4e"
    sha256 cellar: :any,                 sonoma:        "3397a8bb238907886a1d93110aaf8acca41ad8557091ac59fe794e409231ea59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20bb8b0589520c8100fc79dc892323978c4daf5aa5a1c3207b36861ec375421e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9467d3f59ff30797c40b8105db89f2e00f473995d2e6c7949b071436e47e345"
  end

  depends_on "elixir" => :build
  depends_on "erlang@28" => :build # https://github.com/electric-sql/electric/pull/3992
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_TARGET"] = "application"

    cd "packages/sync-service" do
      system "mix", "deps.get"
      system "mix", "compile"
      system "mix", "release", "--path", libexec
      bin.write_exec_script libexec.glob("bin/*")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
    ENV["ELECTRIC_INSECURE"] = "true"
    ENV["ELECTRIC_PORT"] = free_port.to_s
    ENV["LC_ALL"] = "C"
    ENV["PGDATA"] = testpath/"test"

    system pg_ctl, "initdb", "--options=-c port=#{port} -c wal_level=logical"
    system pg_ctl, "start", "-l", testpath/"log"

    begin
      (testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups").mkpath

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      tries = 0
      begin
        output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
        assert_match "active", output
      rescue Minitest::Assertion
        # https://github.com/electric-sql/electric/blob/main/website/docs/guides/deployment.md#health-checks
        raise if !output&.match?(/starting|waiting/) || (tries += 1) >= 3

        sleep 10
        retry
      end
    ensure
      system pg_ctl, "stop"
    end
  end
end