class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cf6b03d711328a5e867e2adaa4b2b15d945004ef1bcbafbd96a5fd910b88806d"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "839bc0dc92d248c9d386a541677493b9534f0c3b29ee9e2cd5fd15656817635f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5317b957babae51b7f1c2f49ded76d5d9fedc8b40f76d587f28a0d12b1fc075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e976e3aab957d23d1df08a35c513321d4355a1effddf68c998cda472775bd57"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4bb7f14609b28170a2e4295fd8c8be67ded79d880f70fe667c7c0bb9d78265c"
    sha256 cellar: :any,                 arm64_linux:   "8e77a0d0c413335d1595673093801c3d8ed8b2ab5ffa644cb53e24d5f77938a7"
    sha256 cellar: :any,                 x86_64_linux:  "b279d7d4d1512f6bd0715460f10836b2d79d046e467aa0dc41caf9d4ca291ff3"
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