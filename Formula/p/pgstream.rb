class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "1088b083e8469bcc1d945865ced7602df82904bd4c75e1788a601e6facdc5686"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90263ea366d25a61548b7d65a84dbd26fdaf6368e43a4f2e58eb628bb7ae21a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ef52a8c9ce142d7c4f8bd7045ad39e90d94d8d69689a9976090474cb1fa241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b7dc3784cb7656710eb4bddbdd4781822fbe0c3af4baed6a7069996bd41d765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473c10c3f6057ae547f19732208637ca4df9b43bd6758ee2f91679380aeff5e6"
    sha256 cellar: :any,                 x86_64_linux:  "343be461186cddf16ae95e4eebeafaaa90b7b2d397c43297e017f7b09fa11688"
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