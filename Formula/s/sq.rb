class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https://sq.io"
  url "https://ghfast.top/https://github.com/neilotoole/sq/archive/refs/tags/v0.48.12.tar.gz"
  sha256 "8675003f7b83004d536834f7d75eda98859b49e53864eb96bbb1f658b0b18ff6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95689f16e812bac6c80573ecc475ce1ca695f8cfe38a243e7d5adeb2f7a037c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16553cf15e1c1729de5623462854c11de803555419c07d69deb79ea310ce3bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d7dd9c888c1b7d8d1dbcac181492210ddb6a465cd621f0e11f7c1adcbff176b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d05ba5bb32d00bcd5d2d21d55ecd2eab44fdffe6ea75a32d52c8cbf81591913f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b0ba7e49b88c882bbad53f17bf1cc28ba6f3c14657832e03a0be5c65a8bc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919944a1e9fc0b09adbbeadf69a8c39ed04bda55805f5a96a87d1c4408f8bcb0"
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