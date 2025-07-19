class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "59269d83302a93cf24ca9221120358b1a9a5b59b0a7207021047a680eff4961a"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4498804ec55917fe1551230062b4392debcc195390d385ab0bbbb26976b1dae2"
    sha256 cellar: :any,                 arm64_sonoma:  "b840de3bbdfa71228f03ef21ccac7dc270510c9055826e287d71598e7ff6a60b"
    sha256 cellar: :any,                 arm64_ventura: "33f0f557c3ea98db98498a0b9274d902196476d1a95194a98e934d5c85a48b14"
    sha256 cellar: :any,                 sonoma:        "33b0f03376f2bb0c0bc2ea4471944d1963cfb15e4f83845bb951089225929efb"
    sha256 cellar: :any,                 ventura:       "99ab9e5107d859a10904aee6a88b711588f6bcc8cff9b35478a56f7664f05105"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc86e0ad4b6565ce113ff2588f8ae78ffeacb67973d0cf93e144c0e718eaa80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9a02b7be7d70df01a772cb3cccc7aac21160c6a9ad631723fc17760bceb363"
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