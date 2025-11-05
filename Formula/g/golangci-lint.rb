class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.6.1",
      revision: "e3b3bac5dd24906c205db9224fde52efd4d238cf"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "add170178479b8c18d10d5c47cb96de619366cf416c6e1c3042c115dce176d4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f96a4c623d81dbe9e14a833ace9b3597177160141dacf3131bc5ef1e6c0ff19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb82b3c4cfac1e9b45f7066ccccbf8cd531e4ac85f1d51fcd1a177bff37bc575"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea60501401045809aeba61e0a938b89bfb061836db43950e2bd1edc0f42bf99e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d8832d457a59a34555b2471f606be4d7ecc6d2ae8c69351270eee083cdb0caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c6f75a8ca3801166584d101ef8c7aec825107c419a0b014d3726edbee31e3d"
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