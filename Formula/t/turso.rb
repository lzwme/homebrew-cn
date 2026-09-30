class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "b5fd172a9defb55e78dec9c574dcb79b0d988a5bfdfb59b64a591890f3f29a5c"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e4f0902b48a1e96bb1e23fba987b02d2b94f0c7a235025308cc854f39ff0b53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d25148917034ca5cb14987d074752812d343095697158b281a44f306a249cf1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a8dcb094294f18556834b8e2771dff255ba4f29882ba9e3fbffd403c6dec5f4"
    sha256 cellar: :any,                 arm64_linux:       "25b9b5b619eb73efef3ec95e478b1c5fbe0aef4c5f1f435a62f4be65344f2c0e"
    sha256 cellar: :any,                 x86_64_linux:      "244d5201ed3d6f1c378c2a69fa9b2255cbf0e6b5fbcc64533a80606600bcc059"
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