class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.9.0",
      revision: "72798d34b1eb36745915b0d4eea5c2b3b31bdfe3"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7111ec96e2d2c16d6094231fb8d238b0e02764d68d8094acdc811eec74d09855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0907a899f37c733f0498d26e795c56e7d3049ee1d56cfa91029ad5250a68265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02db6ad69889b36a9545ff7967d68267abe13554a1ec6efe3fc54564515aab6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b258aba8244482ce420f52414fda63276d65142d26e502f98496fd7a9ed123d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "045b7515066c7a8a3409fd3e5cd5ce2a64cf97acaa7d7785dd093701b70a942a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56050e07ad7ecf2af73433ac9ce02a6526fc8c91d3000121b904482d782cd6d9"
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