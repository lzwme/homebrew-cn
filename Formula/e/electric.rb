class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.6.5.tar.gz"
  sha256 "d1daead6783dd56a121f95957ccbd9495216159090803435e74d69b736e04800"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f697e4ccb4e9e2b6554d5438246d75b21dd9f339347e1efbab3f6a3574c449a2"
    sha256 cellar: :any, arm64_sequoia: "d345fe6f8c4ee3db326f44d02efaa50efa0a9f09b2b0b93b268413ff8aaae0c9"
    sha256 cellar: :any, arm64_sonoma:  "5383760ef10c63f69680de8542acd8eb3d26b9778d19f7f650e15db29fb6c446"
    sha256 cellar: :any, sonoma:        "cc83d6e235d8f5a30253fccfda588ca1d34bff664239bfd3d26d068270e5fdf3"
    sha256               arm64_linux:   "4dbaf30ef334a1ccfdc952bc0fc48a2b8706116f38f8e3765dc4536fc742ba50"
    sha256               x86_64_linux:  "2c8607f1fa8f1ba0d83435943a564c6a830c3810f6b5299ca687f74861e5c13d"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@18" => :test
  depends_on "erlang"
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
      system "mix", "release"
      libexec.install Dir["_build/application_prod/rel/electric/*"]
      bin.write_exec_script libexec.glob("bin/*")
    end

    # Remove non-native libraries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch
    libexec.glob("lib/ex_sqlean-0.8.8/priv/*").each do |f|
      rm_r(f) unless f.basename.to_s.match?("#{os}-#{arch}")
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