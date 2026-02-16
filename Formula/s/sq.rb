class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://ghfast.top/https://github.com/neilotoole/sq/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "cb3d9f28c980324e8b0e1bb0cb0a72ea4d2a9264ca55689e1fbd311690ec62d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b8b440006b270b982131b78b7eed016122d48c76fab95d42725767dd418a04b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa08a103cf6a61b130d682d9ce28840b540836c83fb4b45c1d3655b06462243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1acc1615e92fa631c714b2403f21dc68f4aa5428256226c603d6ca285bc255"
    sha256 cellar: :any_skip_relocation, sonoma:        "16f78be7ba3f42e7e86869f489457a377bf9636ef2283b01953de5be7f7130b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7a3d7cc9eb2267352d0e5a42342cdb32725553ce24e8f4244f1dc1d115dcde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c50d345889ab0faa5cb5fb4820798b23151fd9662c133247bf493de7cd418d"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "squirrel-lang", because: "both install `sq` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    pkg = "github.com/neilotoole/sq/cli/buildinfo"
    ldflags = %W[
      -s -w
      -X #{pkg}.Version=v#{version}
      -X #{pkg}.Commit=RELEASE
      -X #{pkg}.Timestamp=#{Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")}
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