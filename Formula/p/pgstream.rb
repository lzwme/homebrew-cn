class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "67c4d0d10026ce99e4c236e0d27317842edb809b9fd1cc54183eed0aa1e97084"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e094d456472d4f22e546aaacbcb9f88af626a64d99f4f78f13ef97e148b239a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c4962f7bafe356c8ebf37b6d1701a86a40a6711c5bd07c2cfca52ea6d29e67b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6730791905e1a24d16453bdb056377d97c989cff98d96c9a9e3c785c2bf33a"
    sha256 cellar: :any_skip_relocation, sonoma:        "487741c58123d3e64b167fa41cdce7c0f3a3342d7ff9fd2c49509d04ecf11164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3538b962237086ec7ea5b1aae4a933611ee55dcc0267d07f320b2fe1a9bfca93"
    sha256 cellar: :any,                 x86_64_linux:  "e51d4f0b09a816874845d305b4d8145bac126b333170d5c6fe968083d4886a40"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-X github.com/xataio/pgstream/cmd.Version=#{version}"
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
      output_plugin_libraries = 'pgoutput, test_decoding, wal2json'
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