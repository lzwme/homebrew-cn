class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.3.3.tar.gz"
  sha256 "da556871438ede6dc6542ce77341bac344f5fc8f67608937f9ca20530bc65bd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "045ab5dc297dbb9b7292407786aeb1f2b5fa1735d833988117ad7b0ee639f3de"
    sha256 cellar: :any,                 arm64_sequoia: "1a583ac9e3b34287e8fbbb63e81993672ac34e6072f376c7ee2fff4c9282cd6f"
    sha256 cellar: :any,                 arm64_sonoma:  "7ee71f9b04e86ec27e762e70dc4162a3e36f8284fe652053072a1f36b0a793d6"
    sha256 cellar: :any,                 sonoma:        "17f32a1ccdfd7d7208b117020f1c3a3addfc42db4a3c9478b8c360ed8e1cc8b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f6261497b4f37d44486f99b6fddd1e8e97cef32d77484bef21de86dfa9ce007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd797ba5188ef868e96aacbfbe016f85a4deee62b8c382eccfda063f21835c0"
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
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end