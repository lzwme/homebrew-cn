class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
      tag:      "v2.2.1",
      revision: "66496a99757549ab02ffbadeea72d9eb9d387fc5"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b621e224952ead9d989f281ab67a1438de4a0ff44f490ae3c0f9704d3c2297d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c1dbe913323c2a980950c5c10b4025ae9a762b3c503c224f465451621db44e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba6a667b008e725485f1e18b7f89151774b30507107fa192308d8a1c4222d862"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fa8a4ca64caac6481a87f8384d561695a7c445e9a51b72eb34eb944171ee536"
    sha256 cellar: :any_skip_relocation, ventura:       "8c336ecc646cdfc7e49d808ea6199d34898face58513e05278a4e279e364f1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e85b8ac623d0bf585ab9a4cfcfaf8edf3be2ddee08a7806ce7c756e4983595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a72f77f2f4113ee8136ce9c0dc71d8b5636a309c6bdfb0100aec6ab7c8d251f"
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