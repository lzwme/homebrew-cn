class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "8c83dfa8c3762fe431896ec92cab6637c4f5d8b30e7f11420d27f25ad6e6ad27"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "54af00f59ed7648052778d02e09bcecce6b30567d8ca15b36d4d1925979c7d45"
    sha256 cellar: :any, arm64_tahoe:       "51ebc1f9ddd346e1d41727591188b40bcfc72128355a9e0caf59289caf592e84"
    sha256 cellar: :any, arm64_sequoia:     "0b0b3237ae1e8e6ef24f43653061651cff540e62504df0402e7d42c0726c02ec"
    sha256 cellar: :any, arm64_linux:       "c1a59d18c2e26bfb7bc07730acfda04ce486a05603d4d3bf7fce57dfe246257e"
    sha256 cellar: :any, x86_64_linux:      "bd3b9160020133a4d76dd857f68681a82d2ac633f805820c38d84e249e283a20"
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