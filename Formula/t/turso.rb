class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://ghfast.top/https://github.com/tursodatabase/turso/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "24a77634c628921f022acf90488b35d8ca1aab226c544fc8c7a9e3d3b3832c66"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d84c2b1e2fb3602ac922ffb79c34ad5a93ae39859c26fbe85a7ccb86d712d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d3d3dc4ef594d529052722815c602c59051efd2b5fd02f58e732340fa7ecd2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7773bb8966b388a3a9f2ece398a138b81849f4f0e8963938be5eec5b12aeb215"
    sha256 cellar: :any_skip_relocation, sonoma:        "722ee99d878d1de570ce676fac1068b3ea7d03722fd024fa6f28a0991a6256ce"
    sha256 cellar: :any_skip_relocation, ventura:       "f6fc9a3f4703621d097460fe6a660be5f765e548e4bf415ac655fe106f824999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4a5e1fd572033dc85cf43a301d505f6e13e70ca0892887a340b26b6d3d5863"
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