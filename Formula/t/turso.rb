class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4e090970e8f71790e9499ee76e6ef4019366ba7ff9e9271534e74059e9bc175b"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c6502fc4421c86f0f826bcbe0a49ce984acea566c0459aed19b3d37d4657432"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0afe20e2f25618456dcc365a7c33a2aa54aa131e68fe8b81e3a04bb055b7b477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08b0e326f7328111358f1ca8d1135b5559bb9b4b607b7439005b4db04a694c35"
    sha256 cellar: :any,                 arm64_linux:       "ef7f8bf691028a531b12650545ba90ec7b2642486432a091d18688d4cb93ec9c"
    sha256 cellar: :any,                 x86_64_linux:      "2ffd0daa14a38b44fae913fd9b065b5f3e7aa126a85da70f0eda43b3f3181152"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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