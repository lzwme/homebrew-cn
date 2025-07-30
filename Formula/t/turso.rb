class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "5d1e32cbbb5bab336d1f535abcbafcb4db254e958cf5a07db7969386d1ebb7e1"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d04815edbf7fe5a8130b1b0b09d5d5fe49ae5ec5b67fffc8515f3417bb593e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca6a134199c4bb8e348660a37efad4c7d753c9e30bc568fd7fc07e24fa062a0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15e9d63a075366dbd3768fcbe31fb39bc70813532125ddc96eac944a8238e808"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e6e9d2a3c9b525bb7c443150f391f80f4c12c7d34aefe530bf752d84b249d9"
    sha256 cellar: :any_skip_relocation, ventura:       "ba8e6ebb215ada76a702c0ec87fc456e6c26f998f8fa46ced128571a2d78b605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ddd32c180d8f98c0410f26c90c4ed036fd44fd16f4cf76de74d02b4b07ba4b"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    # Fails in Linux CI with "Error: I/O error: Operation not permitted (os error 1)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end