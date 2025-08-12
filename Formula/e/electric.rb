class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://ghfast.top/https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.0.tar.gz"
  sha256 "58f28cf698cc7d8de8c780fe831932aa62efb207ec443b26ba46e9a0d6242a41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d77cb95934fbb68d5022b728635efda38da9b359e3d7d596f8521814a0c9ef8"
    sha256 cellar: :any,                 arm64_sonoma:  "c92bb0710595e82915596640f6d5fd5c2394325f57a89090ade94e2da47f9cd3"
    sha256 cellar: :any,                 arm64_ventura: "5ad12957265cb407bd227421468efa67771ebe19828a6ee32401d71f927919a2"
    sha256 cellar: :any,                 sonoma:        "737c07d008629bf0036d8f51d9332801193aaa7b9d0f5d8479aaffc2228531d9"
    sha256 cellar: :any,                 ventura:       "b06c3901909e728b86949b21f5ec4cab239a5bba9ab62b1a1c8115b48e300e20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f297de18d0e6da5b663259e2e9a67427d2cbcb2a2b77c04330ece1230ee010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0663309185b4eade5947e6ece0ffc0cbb30d2f121dd32b4e71376927c148383a"
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
      spawn bin/"electric", "start"

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end