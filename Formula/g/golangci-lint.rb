class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.7.0",
      revision: "e6ebea0145f385056bce15041d3244c0e5e15848"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "515fc33ded90cc5bcce79ced4f1dc941ac1e02d1ca939f84f1ef3956454043b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28fc8a4f3523177b617fc9a48a625a768414175b6c4d76f45407cee6f14819b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f2e88f8994da9c5fb4211f7210d66f80f0d2651da995b935525e079c8e9d78a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa8af7609526e1bcb52ecf5769a150c9ee469c6a044bd9a6e5f429e91be29590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "411e31669a22db5268743dea54b8d4dcefe8c894205f07db6b05fdc0a926749b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e22ac049ea0515c5b76d9300107c38b14c2c54aea1b7890f7e033b6775c25f9"
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