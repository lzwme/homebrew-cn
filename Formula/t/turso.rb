class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "26a4e392f59bd986fbeb6596c9826bf2d8fdc40b075de2c02e01445e1ec604ab"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a8d23695ce8d3bcdf5055f603e1749cd800664d9621108f2b75c76ba7705b4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91e1ed68a0e9bce48cacb2d6945ba81a9814150dcfa19373431877287c5650b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783cc033d8644618dccc313c27f6ba82192826a10f7b1b8be7e944edbb1a82c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3edc81ebbcbc92d3777e08d3690a071a9bd054349e9c97674450515658ea59ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "134f66b0810151569efdea9e80a504ab96facb2401c67ba70ffec84ab81916c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "735fe76bbd74b0f418d708597c6bf2f9332dc90647a7dba20be38354412c1ff4"
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