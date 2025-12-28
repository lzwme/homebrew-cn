class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://ghfast.top/https://github.com/neilotoole/sq/archive/refs/tags/v0.48.5.tar.gz"
  sha256 "4ed9cef836e66174b6e01c8d410cd393aeae7f7069a428a7ab2adcd1e282cf68"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d3d13d047ab5f8c92bd86f9b834d7b5db518aee41c0055b22f8c26cc0ad8eb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165e7742ac66e6d7a4cffe91f9b589c92149ebcb22bc5f4d74e390ca8f47b3be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e2e0d899741aeb53f2025c3af772478921692af3367d688c1c5d433f5fb55f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c62c37e5d001f5d2035a54327de20409d527d2b22638cfd64b7c544e32bd49f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7418d1e8666a52752ea5b7bd4106d684472b14e816509744843e4363023345a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21db459252b548be3859848c8146ec67ba36ad5a18e6270e96a082221f34f5b4"
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