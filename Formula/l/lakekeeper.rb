class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "40a791daab5f37f2799ad653702a4447b162e9faedc58d4c358a1f79eaad258d"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aad4db2adb2f173c88d1e0df0186232a44ec423c2a073f69868a0ca300a0bbaf"
    sha256 cellar: :any, arm64_tahoe:       "f41a65bec5d95fd838990ffacf88cafe13ce4f58fa75d87e4955c2d474203330"
    sha256 cellar: :any, arm64_sequoia:     "5d751c446d8cad6d24143df41de7cbba8b21d35a1dacd2a6f38f6c6d9115e795"
    sha256 cellar: :any, arm64_linux:       "0bee96ff51460a2510fa960f6d9840dd7fc52ae0e02d94d688b95e01c0fac99f"
    sha256 cellar: :any, x86_64_linux:      "53daac475a99a03377049df7b6929c3c064aae025ee6bb6270508c4f35b66f0c"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test", "-o", "-E UTF-8 -U postgres"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["LAKEKEEPER__PG_DATABASE_URL_WRITE"] = "postgres://postgres@localhost:#{port}/postgres"
      output = shell_output("#{bin}/lakekeeper migrate")
      assert_match "Database migration complete", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end