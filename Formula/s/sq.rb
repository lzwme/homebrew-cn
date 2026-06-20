class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://ghfast.top/https://github.com/neilotoole/sq/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "af4aa452a2ef52274ce92b50c2008bb5b874fb9d802a84f48bb7392b8e28eda8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eefa37bd2c74c17d835eafd791f7d76a35c012cdf102d7c2acd7bf7a939fddd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dc0e90545f8dc3040006c0fc624369ecc4623a4c65b7551f1fd827186e8ab32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39dbc5009f5e86b5a00deb95dc263f717876bc56148a733827e6e6332e0a1d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "08496f5ff901aa7972509d26b03235b2f9f6ec05b812ec85f769c4d3822597f9"
    sha256 cellar: :any,                 arm64_linux:   "c237d02f7f1d981c091d3c4f94e1fcea0721681d32627b417beaa53747fb207e"
    sha256 cellar: :any,                 x86_64_linux:  "e60bf1f61356c807145c9dd8af6a436c65b1198fe7f8279b8f769e5737c03bc3"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "sequoia-sq", "squirrel-lang", because: "both install `sq` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    pkg = "github.com/neilotoole/sq/cli/buildinfo"
    ldflags = %W[
      -s -w
      -X #{pkg}.Version=v#{version}
      -X #{pkg}.Commit=RELEASE
      -X #{pkg}.Timestamp=#{time.iso8601}
    ]
    tags = %w[
      netgo sqlite_vtable sqlite_stat4 sqlite_fts5 sqlite_introspect
      sqlite_json sqlite_math_functions
    ]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"sq", shell_parameter_format: :cobra)
    (man1/"sq.1").write Utils.safe_popen_read(bin/"sq", "man")
  end

  test do
    (testpath/"test.sql").write <<~SQL
      create table t(a text, b integer);
      insert into t values ('hello',1),('there',42);
    SQL
    system "sqlite3 test.db < test.sql"
    out1 = shell_output("#{bin}/sq add --active --handle @tst test.db")
    assert_equal %w[@tst sqlite3 test.db], out1.strip.split(/\s+/)
    out2 = shell_output("#{bin}/sq '@tst.t | .b' </dev/null 2>&1")
    assert_equal %w[b 1 42], out2.strip.split("\n")
  end
end