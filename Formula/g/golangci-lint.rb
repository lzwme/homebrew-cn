class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v2.0.2",
        revision: "2b224c2cf4c9f261c22a16af7f8ca6408467f338"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc815d5638bf8af11cee9534391789ffe476b5605865edfd0ec7262a05a446a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "653f7c7630fd678e730821a2191da20c62cbb30c45b73cfe94fa2038dce71d62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4bf5531abcf6e15ab365c66ccd0f5c2e2116505883b58717b0d9a30d6fb76c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "21a9e6727e919d71dc8344ecee2b75c041d16fedac89ed83d5459a4997f52ddf"
    sha256 cellar: :any_skip_relocation, ventura:       "c19559ff2ba3e695a3680b20b826045e5e838eee44d620dda9a8ae2631e3a02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4284ed6237cae75d36798310f61545d168595d9a5cc15c67212c7fe6bd96d13"
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
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}golangci-lint run #{args} #{testpath}try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end