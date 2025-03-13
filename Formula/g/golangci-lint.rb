class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.64.7",
        revision: "8cffdb7d21e5b2b89f163f70c60ac9686c9d6180"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b768e946365898af1dc7ef499ed4d38ccc798e6aea9f592ec35e2ef42c3424c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f56c8418bbce2eee76c66b7e3d9dc1fa311dc951be9bb0b3b8addfef15141cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02738e6ba0676e86d087db1dd733c973e82444aa8b37ae0247d7db36bdea5bb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "99326fa797b2e40abbc83082ed14086d231641f8538ebb9e3798790bc98ed6be"
    sha256 cellar: :any_skip_relocation, ventura:       "27739b4bb7e2dbf9d9b5c45ff0b819c994cbe7f67a044b7370f0d3ce94a2a147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2cd1854b0d66afccd48be3568c9a4d9571b97de1cf8fc07916ad370f0070be"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgolangci-lint"

    generate_completions_from_executable(bin"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}golangci-lint --version")
    assert_match(golangci-lint has version #{version} built with go(.*) from, str_version)

    str_help = shell_output("#{bin}golangci-lint --help")
    str_default = shell_output(bin"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}golangci-lint run #{args} #{testpath}try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end