class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.64.4",
        revision: "04aec4f787c25a737641f3d434059880d2af0f53"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "887027f627be3d610c0a2e5de4518b24086a429d9cdbf4ad04be73b4ed71c81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f2d5916fe812ace5210ddf3c1387fe858be3f00feffbbf037fa3835153a25d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0084ea555b229defc51b4362a3807371f551d786a4d39b86f043e3b296e8b188"
    sha256 cellar: :any_skip_relocation, sonoma:        "6793fa430f5bb5c38e9c45fc3c9ecc449f7a2cbd907614b7bf21fffa1a21e3b2"
    sha256 cellar: :any_skip_relocation, ventura:       "3b3f46957266b94048e1fddcb10a31e46432f1a50bb9d1210eecbabaae414fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16966a71f297e28dd5e00bf80e7d48dac843a7d4ccc0dadf6d7b0496adc3c015"
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