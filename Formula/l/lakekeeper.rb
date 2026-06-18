class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "0ad762505286c5fae7e590fe6c21983e5c77fb6afeae615e7545137df9c3c6d4"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f593356ca9ef4074fd1d7e8c0b84b07949d1db598bc4bcdf0ab36837316eb0ae"
    sha256 cellar: :any, arm64_sequoia: "239f34536bd8b1a920638ddc6dec5230c16e8b4037089d61a1a45ccacd9ff0cf"
    sha256 cellar: :any, arm64_sonoma:  "0e687197bac79d67fec9f7d62254bc8578a321d1e45f6f81f0b522460f58d699"
    sha256 cellar: :any, sonoma:        "0679b2e2c0a05a5fcf12caedca29771c1f6eb65268c5f2a88cf7edf95df53f7e"
    sha256 cellar: :any, arm64_linux:   "73a74d47a2273fe258ec33d49cfaf7f8bdfc357c87d7f8c7d668777ad1b4df30"
    sha256 cellar: :any, x86_64_linux:  "a096a855fc4f15fcc43d0e7ea76691d8ea7627630d1a0b3c73a0e86c6c3398c4"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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