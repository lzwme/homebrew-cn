class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "c66d2ca9bf9077e985dcf73c42b1e047ca040f02af116ac6ad416c644e212064"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0fa5a90d67cb682bb86aeda90bcc9eeb401ea5b23c29e4deb1a96f711054a2c"
    sha256 cellar: :any,                 arm64_sonoma:  "415eeac806a17163df776577ccccf9d1b563e6fea14b3c1e8ba2fdce080fe723"
    sha256 cellar: :any,                 arm64_ventura: "74be363ec979cb61a8fff6df7748b7fbf1a65bc8b2cdade9a5d590358c0dd941"
    sha256 cellar: :any,                 sonoma:        "ca749b0b25ed835cd689ccf863088d94de4ff137237b47d28dc635f94c517cae"
    sha256 cellar: :any,                 ventura:       "ab8621f0fcd75d386e0b127472c35b2043819c4de818abcc9309ba42ad635fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db376229cfb85fb924828e9e582369ea53cf7439b510d7befd53daab15c1403"
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