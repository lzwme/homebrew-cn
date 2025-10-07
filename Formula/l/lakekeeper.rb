class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "474334f850e368a68db594d90335bb63a8b7030aa805b642d119ef63b87b5344"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "733c5e85e9be64a997b74947cfd3d0a47586bc444a6845c66c14711ed106d7d1"
    sha256 cellar: :any,                 arm64_sequoia: "5c4b884767d325179c5c094ced4c62e399835f3a46eb01f8c33ceb57e86fb100"
    sha256 cellar: :any,                 arm64_sonoma:  "b11c11764308e5b2a603170c87682f55b0f4f16828fd085325321a76fbaa1fa6"
    sha256 cellar: :any,                 sonoma:        "f7bedafeac8da1dad4918fe583eb6e507bd299042ba8126b49f9cacdb188b98f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac5b2df31faf5f820d7844d061b60e2e288b1825319ef351f4b330365278f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a18459f7183ca9d50ef3c96a1c1dff99861cda7501617857a874a586b595e4"
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