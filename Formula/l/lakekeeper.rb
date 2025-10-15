class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "fff100849867c2412d3e1d912df305a2e25747d7b92c3f5651d5c259b327fa5e"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33eb12eda437de9cded4e0b39207580926c5597cf683c252d4dba121d1efdb4a"
    sha256 cellar: :any,                 arm64_sequoia: "8a1834799d76cc172a8a87b78f3357a4043b90aeb14ba0056e5af389d82e197b"
    sha256 cellar: :any,                 arm64_sonoma:  "52a9f01c63da06464648706c4b5247449195b7c67f40650431ab50ca8c3bd952"
    sha256 cellar: :any,                 sonoma:        "df8cd30f1b5d29e950a88edca6fc3fe6517ead3f9bde6f9b024e6559722c28fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f0d8111f4ee43a8e51442df58f3a0f1d42739b877b4af627629281903ba4e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b322702dc0cf1f0d49dc971f1a90c519e543ea3c81b51b653b5af1d26f505d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
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