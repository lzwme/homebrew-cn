class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "baa3cd3f8fe7738052b65cfec67b421d19291988c3215f1bf5f870e0ae075f91"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe26d89a63e44b2af37989ae89cc9fbf31f2fe53cefa5b7d1919f892194e33ce"
    sha256 cellar: :any,                 arm64_sequoia: "e1d0185c0dfc5f55428aa925ecccb14af06b03a222822720cfecab43d884dd41"
    sha256 cellar: :any,                 arm64_sonoma:  "ba4958e2b0343bccaba19ff956e04b1f7b0671a09a68e2058aaa59e0466fc94d"
    sha256 cellar: :any,                 sonoma:        "25d25b90ff1be060c8fe4673f9207cff82382bb7f119bfb0a6d1930c1d4b7cc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e38cc36e9989bd59defea8d30d9345687508df27b2048a86f35524762592e09d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb6358617a77a23a0d7157fd63a05ef7a67105ed112b8b75c69c678cc0f0999"
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