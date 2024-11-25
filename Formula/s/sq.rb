class Sq < Formula
  desc "Data wrangler with jq-like query language"
  homepage "https:sq.io"
  url "https:github.comneilotoolesqarchiverefstagsv0.48.4.tar.gz"
  sha256 "4692a71da5302f0f392721e9d9f28676d5120aefe90e81dcab54bc3214882977"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92be5a892e8a9c67f1103b47bf1e0f264a661a113db4d12967eef3cbb64d8000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95e93c5e11e1c5e90b5993dc13de7b83f78e6ecccf058358cbf177591b12b010"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d136c58af98dc7df95672ed52d2eeaa27fd057b9b2579c25d7650c769ab07340"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa5f1a036b7c4461056d49d6c81133e4f7cd9776ad16f25ab33322314678d4c7"
    sha256 cellar: :any_skip_relocation, ventura:       "7c07ea074069ee8fb544a38ef5a8ecd2f2f6babd003bbd069d04cc6a6b84485f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d4f10847e486477de56fe0158991f5757dce5963c63ee708555c32e782eaf6"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  conflicts_with "squirrel", because: "both install `sq` binaries"

  def install
    pkg = "github.comneilotoolesqclibuildinfo"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", tags.join(" ")
    generate_completions_from_executable(bin"sq", "completion")
    (man1"sq.1").write Utils.safe_popen_read(bin"sq", "man")
  end

  test do
    (testpath"test.sql").write <<~EOS
      create table t(a text, b integer);
      insert into t values ('hello',1),('there',42);
    EOS
    system "sqlite3 test.db < test.sql"
    out1 = shell_output("#{bin}sq add --active --handle @tst test.db")
    assert_equal %w[@tst sqlite3 test.db], out1.strip.split(\s+)
    out2 = shell_output("#{bin}sq '@tst.t | .b' <devnull 2>&1")
    assert_equal %w[b 1 42], out2.strip.split("\n")
  end
end