class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "8da921065492f0960236a0b02cd17ca41382df8ec1219b4864ac5eeabe90797e"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a0ba7eabc821f28a97088efe9740b4bd105fa380adeb25db8237709f9459207"
    sha256 cellar: :any,                 arm64_sonoma:  "c76423151d6d9b7e969fde0fe0d14c6959681e4f5274e651e05e76c620ef22a0"
    sha256 cellar: :any,                 arm64_ventura: "1af6cfe08ac1a4f5d7ee432e224a59da6c50e25bca430e8803851085e4462d3c"
    sha256 cellar: :any,                 sonoma:        "f0c31d5fbb8ec1c40e1725c3e65d12e1f449af0dc785194510aa581bf8867632"
    sha256 cellar: :any,                 ventura:       "bcb83b894d5618f455589ca765e0df67fee70705b8ba5b1387eadbb0026b94a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73c45566d35baaa9f3f1ec688b2142d403ac368a5c5706c8c3663b75ca1329ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a46ed648807647c1da79775969d5a09eabefe92f3ce1d3b90ccb5c19c1f725"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@17" => :test
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test", "-o", "-E UTF-8"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["LAKEKEEPER__PG_DATABASE_URL_WRITE"] = "postgres://localhost:#{port}/postgres"
      output = shell_output("#{bin}/lakekeeper migrate")
      assert_match "Database migration complete", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end