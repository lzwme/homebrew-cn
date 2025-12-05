class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.7.1",
      revision: "a4b55ebc3471c9fbb763fd56eefede8050f99887"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0abd7f25c825628849a1fb1b5e63fd285edbca8e7062f96f5206f9efbf236e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66aecf1d77d4175900667b7a4532b50943f6152ced7cd0e57a38c00ce0737b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "492e8fef36b21aff325849a0641af9ffbbdbefe8c1493e6dc2981034054f4605"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd2fef80768c99bac1bcde7b0eb603bd495a0cdf4c6a0194e8b422ae1564c2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc50606ce9d022e5d92e8f73c6d9dc1b9732dc04f3b00c2727051211741c52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3094de1597464bbd473deff2dd913c765ceeded7a6f9f356f235b9646702ab1b"
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