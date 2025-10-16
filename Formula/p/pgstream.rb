class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "ddd6e59ebb3a555d8ca31aca8d67b8671b407b58e37c8cf837678a6e331ec2bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc7ecc6a81854fab17b5898381b64865588f8761cd4d81b1a832a9d9df89e05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc7ecc6a81854fab17b5898381b64865588f8761cd4d81b1a832a9d9df89e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc7ecc6a81854fab17b5898381b64865588f8761cd4d81b1a832a9d9df89e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "22cd3bd1befa3efd0a0b434adf8f27167aa1ae4f83a70702083bd82abd8c6a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd4b0f615a899d3060264666a01546caf0b0fe14098c4ea7ede6d018b1a95ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48bd78f2df4ebe2980f4b38e44d0cdf9dfad050ef5b181778b0f6c670bdf69a1"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end