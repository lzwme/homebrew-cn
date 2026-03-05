class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "901d5c8b8f1818f8e32643caa864a323a0d97e2d43d3a8e129e50a22d468c1a6"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a913dab1aa68da9ce49dbcada65872b23ad202b41114094ad6ae6332458b6cf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f9c2095214f34615678e6e076dd422089d1b985223c6e4c6b80607a0c9cc3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "865332389e0d5690f4f94cfe1c4671bc96766971d012552b7bdf69a620766fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9c85d4b844725379e7b956bf502a71cc74d78ab6ded38a6efebe5a8509e1539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb2f5a1a7c90057a3bd8866bbd5a8ecff7233c431c7304a798b39e5f282c8a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220f7f62a21373fd1c8a9a8dfbec06a1d4e07e52f887a06667568de7a4a9b94e"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
        r.winsize = [80, 43]
      end
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end