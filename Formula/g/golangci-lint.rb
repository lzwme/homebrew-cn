class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.63.3",
        revision: "e1b7346fbbf88fb8501afabca53c08e41d959e0e"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15fe0a29b4d01ea5a2af26da91d696bf5bf2435920411fc013730596cde48a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1527058890ad95f0a72a8d459a1fc8d566d8a09f871495fb1edb9932bb17f888"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e5097907ec4cd1d229a12c0c5093eb74e6fea87614be25df2294abd783d5393"
    sha256 cellar: :any_skip_relocation, sonoma:        "b944f0ba400a4ab74b3bd7ea9ce8b2a1912853c286613bb5ff321b3b0fc16aaa"
    sha256 cellar: :any_skip_relocation, ventura:       "8c806e5b3571e8a46eecfa8cc0c2b6ddcf049a34c6c6673cf512938340eabc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21196c0642f0f11766371ffd021a839632bddeadb84666d0a64d273326c32fde"
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