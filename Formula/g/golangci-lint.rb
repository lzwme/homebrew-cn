class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.7.2",
      revision: "9f61b0f53f80672872fced07b6874397c3ed197b"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c72569b2643ab9ee31ee9a44a11dee6abcd6ac6d5ab1b0af573cfd6bb921b356"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d330bf7c9dfd556a1ec0e928c71406ce65b5e47cf206171698965c7cedd423f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c553a929ddb7d3a96232177ea76fecfaa5e9f31a70097e490247cfe8b1e102a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f40f13f6f5f3a556c18a657f83a34c1f017581b54d26b7c3a88204166335cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3bef1765b5963d77d0f75138341da616c88ca4d44b7f80c576252cb22f11b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bd9a868dfc3f40226b69018000ba2076285a112895ea44a43787af1e0ed6022"
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