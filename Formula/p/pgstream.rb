class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://ghfast.top/https://github.com/xataio/pgstream/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "259c9bf9bfc3edd9a0f0b4dfefdae0e368298889ff380267dfa9dea3756c7aeb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a763b060f74dd647a801aaac1ccbc1b881a45362893a7b56a6dae259e1a51e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83a763b060f74dd647a801aaac1ccbc1b881a45362893a7b56a6dae259e1a51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a763b060f74dd647a801aaac1ccbc1b881a45362893a7b56a6dae259e1a51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "436ab4f0ecd2e913fc60e23379683ba04e7b37616ee7870817bc86aeea31c06a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9570aedf01813f76ffa3f38e52efcc068976aa673f346bb96afa6d268762af12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4581c4c0c47a1c016391e724c6653d2d8228b1800dc522c4be0c932f690b8d3"
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