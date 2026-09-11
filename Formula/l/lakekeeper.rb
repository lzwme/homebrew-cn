class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "cd1e615ee48b4c60d280bd5f1cf7b874333c96d719b7f0533316bb895ebe2289"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8392e377b5da592e1b0d1a24600cdb7d7297df88c98a186210d9d95a9ddb53b1"
    sha256 cellar: :any, arm64_sequoia: "7c684d77ba64fa9464b5f241254924e13dab7a00908a2a88c08c6b9b39838a14"
    sha256 cellar: :any, arm64_linux:   "59840701c42233676c1c3c52c77c83b79787e3991140ec2fdc3f613669d5b22d"
    sha256 cellar: :any, x86_64_linux:  "3792aad6cb1731307c196590636bab7087593157cdc1b27dc927109dccb54d1a"
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