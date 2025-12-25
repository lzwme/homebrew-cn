class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.10.tar.gz"
  sha256 "8c245c4c088668d365268222ca51c8073b6a214447337f90a85b569d12a9abf6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84ce89521dd01053f76a32cd0c0ed0b678790c868ed700a35956e59abcfda133"
    sha256 cellar: :any,                 arm64_sequoia: "d42317581c5750d59138ddcb354d4f5929a53e578084641ae4fedc180ca1480d"
    sha256 cellar: :any,                 arm64_sonoma:  "00d97f69b29872dcbffcb599c52350282d83b4f9f7d92b2e0bba1370a1d78146"
    sha256 cellar: :any,                 sonoma:        "4370f460accf0d4675effb9c6aca44ab01edd4a0426b671ace825500fa2c4276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab22de6c063930ac112055f3dd6fb0841a2d5d7ea85dca7573425da5e60fc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac27ba72613920984f5130c4f0a80ef60efc99bf45ad817f9d49fbf64e77e8b"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end