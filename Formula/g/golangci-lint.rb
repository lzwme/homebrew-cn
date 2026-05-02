class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.12.1",
      revision: "9aa24e94ceb7d1a8ccbde81e7424629467299a7e"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07d0fa2b9e4959a9d76b45dc87991f82f1f96e1d5c29cf5e80e1db1a329404d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bd85cdfc8b3496642e79f6cce9bb071dfefb228dd4be27a4c93d309fbb8675a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418780915c4a2ebbe903410fb035bc6cfd7c8049b87ef4223ede52044106edcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba617a2e5362936252db93494703ac7d50b3eb631cb262e2a3b18c0eb8bf43c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c48326696408ce6ec59705103dc2db905a8c6839ebd2e111f62f56ce0c20d5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aade995a1e455366d296df5d3b09c4b152e294b4b67ea2f66ff4b0458e6a9c6"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
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

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end