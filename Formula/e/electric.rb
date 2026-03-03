class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.11.tar.gz"
  sha256 "5655761c7792a33b16750a267f0fac9cf4fbd31ed81485e8bb199cd025f04c09"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7dcf611c4d3534d365c41c73d59f8544f9b05aa5c0ec89c22e3dc1787bbbe90"
    sha256 cellar: :any,                 arm64_sequoia: "4cfaa68faad7ab37bb7f547666ac76c5d78935bb405071684316914c1b1c6d20"
    sha256 cellar: :any,                 arm64_sonoma:  "c5d75c4c7c123557c7568a854d4e8e8fa0b7fa7373b9f5cb32f1fb2ee8cddb81"
    sha256 cellar: :any,                 sonoma:        "419f51688acada3127ee398b5653ea9dac7fa8ba1982b5d43779b8e1f74e0b48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5424d39f3b96d5a71f0b0e9701482e97e0a8a3e5746d42b9748a32a0d9d0fcc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75857091f75443cc75b5fafd1081052e78c14e4cd3ea936e1346ec456246ec6"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
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

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
      ENV["ELECTRIC_INSECURE"] = "true"
      ENV["ELECTRIC_PORT"] = free_port.to_s

      mkdir_p testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups"

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end