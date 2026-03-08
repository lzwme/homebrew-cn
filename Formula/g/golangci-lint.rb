class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.11.2",
      revision: "e8f621973e2dfce68b7839ff16affa09cb103239"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74e713dc3548a4b4a5a1b96aa1f5db3038c4cc13104d7b45fa1434e24f7c46a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be558b332c26982c45f9bddd5412c288107b1e2ac11c8bc67646c4c833d6f2ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea97951f3f3c4fa03802572aa4796d7124eb4f7f2b4096b37ba4e850d8e32c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf067334ce111c537a9d0c644d6e191ab8128cceb72538b4484ae3e6789bf188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8b20cbed72689a0354961adf85cad559830fc6971ad8039d84ccf5057fb64e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a71f016963db40e25d215a97bad807cd298fce3e008ec6cd8e4e5d31b923ff9"
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