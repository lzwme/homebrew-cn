class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.6.0",
      revision: "fb09c3715aa607741924f220d6ce52692d012753"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3da77cf8e56d73c94272feeb4b2b2dc678536ed086a82b099f4b309a3261aecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "563071e21c236ccaf5fe4fbe63af69650adc607df6d1d5e4d5a3a68b03a6a03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a9635d9c7f26d44914e8a52af72420d5573f452c90d2063d5e94020d9ddd16"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad8cf3caef9628c8d095a5cc8f828e231811cb094bb44aa16a7a0532076da30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ad557f81d9041d5cb52591fe9166f2c3e6d16545fde30264ba23dfa6404076e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0c76507605477600c93769f64e8706b5b3e9ac38cd56a7e9dc2996e8fefa6a"
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

    generate_completions_from_executable(bin/"golangci-lint", "completion")
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