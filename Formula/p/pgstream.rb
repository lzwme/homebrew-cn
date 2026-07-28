class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "ddf3b833b45ac9177a17f8305c4355aa74a490435047214c6aebec59edd55c00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac2ecc3a6f85c27867fde005a460f3a4915acf15293e349e052a4b8c098a1b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac2ecc3a6f85c27867fde005a460f3a4915acf15293e349e052a4b8c098a1b45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac2ecc3a6f85c27867fde005a460f3a4915acf15293e349e052a4b8c098a1b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "58582fa175dc549e6b37ef0da83621568731046e813748b043abaab18f65014f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "835789f65b53116b16b4aceca00c7db5b8dad7bc841eddc4c919203dccd90340"
    sha256 cellar: :any,                 x86_64_linux:  "6360822f9d20395f7a88be418dc11396a8f5bc12af9a10ea26b909f964cc39b8"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pgstream", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~CONF, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    CONF
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end