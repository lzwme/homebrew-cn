class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.10.tar.gz"
  sha256 "ee1d571717a56681b7915a0ad7bf4981428dd107cd2055ab6da2a7ec6b45b652"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "267d151fb2597f1a3d9672940935a41cb056ab48371d5022d84448d593322dbe"
    sha256 cellar: :any,                 arm64_sequoia: "a2a3e9156660ff59b85731647c64f12d22da462462b17934453249e4d80b542c"
    sha256 cellar: :any,                 arm64_sonoma:  "d9803335e628642162577c59b9bb7c8975de8a531f183c94121b3f8bee1e5e79"
    sha256 cellar: :any,                 sonoma:        "1ee03e964b7cc34d51f43055854951f57020a91125add31c246642cc1105a602"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6536aec3358c0dc9f3d178174a64b388112b5f6c8e44738d7ebf33d9aac695a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e11efa1d6e83df446f7acd7dc22e8058224d57e765ea51c6ae5f62ea471ab7"
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