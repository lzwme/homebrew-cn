class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "1ee082caa5c6aafd41dbffcd0cde3c1be4b239e2fbcde73d564114defdabaf7f"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04666e31acee33ee2272d42d94fc3126e0dd210ae9c98d9180249145b5fe9a2c"
    sha256 cellar: :any,                 arm64_sequoia: "db6e48c9fc787009cb991d283a972b74aca0c30e8e72c4165a1859a5c2a91f6c"
    sha256 cellar: :any,                 arm64_sonoma:  "acf5ce5b8fc3fba8e2919ec120b2d2888616c2f601bde1152c76d181ce4f8985"
    sha256 cellar: :any,                 sonoma:        "525ad9d7be16cd7bf58b9afe21d00a27ee8a5b68245792d01720058809685e70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd06fddea4c4518c824da82bc385cbc131f34913424f227edd372e10bb770e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1bc4c397ad716dc0522f3276fcc4a77c6ea4242bcbca9b7393b51af30e4386"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

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