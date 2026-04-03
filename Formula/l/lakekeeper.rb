class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "9c7107649ca89efa435aaf5b871d54931ba690502f0bc504584765b37c68d85e"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "087d1a57ea03f4abbffe75b474eca40cf0de73752b0dbed57859aabe466eb0c7"
    sha256 cellar: :any,                 arm64_sequoia: "741fdfbb656fc23a22f89a63b1b55acdd9d1a47aa1114f24268437b0d7f73057"
    sha256 cellar: :any,                 arm64_sonoma:  "0518ac179ddb7f4e7837b369db01cbfc266fed3aef2d18c40601b818af42ced7"
    sha256 cellar: :any,                 sonoma:        "ff837fc31a52847c0c2c738216683172db3dcfd146096782fa2f1694ac948b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1001ee5d06c1dd5d4d47953426ea3315177dcec00c286ccf065e83f1aa80c84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99ec69f35eba54f6f9126542535b1a7210cd27718cc9e449be18b5a06a33191"
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