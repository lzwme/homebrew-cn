class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://ghfast.top/https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "d41e20f785c6d1b8b68d04a2d2c1eb1b53af0a47c4d2884414695078666079aa"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bcef73573e51af36ca8ae781ac55fb61c8acfcdcd4b71c8dcf379b06f35a2411"
    sha256 cellar: :any,                 arm64_sequoia: "b82c6c6b933057656024f18bca14fdb801e3ae09f621626edc9b0f7923bfc5db"
    sha256 cellar: :any,                 arm64_sonoma:  "5d6b2f008349178ed9f792f6493e2a056f5c3063dca6632f81681e61d5a88089"
    sha256 cellar: :any,                 sonoma:        "f98a4cb69cda1598792f0e9faa7e708ab9a3c8b363252beea1b4cf7858768f36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3dfe77e60e16aa2429a9f228f221c3e715996904b5f1388823c608e323d9fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79bb3d1e7c073050d0781ff6f4a2655e24b78edcd5d5020090d28d2a679feff4"
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