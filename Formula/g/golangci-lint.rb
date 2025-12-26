class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.7.2",
      revision: "9f61b0f53f80672872fced07b6874397c3ed197b"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47edf94e70bfe59bbf7c548b557d164f1dba545ae90f697ebcb3235d5bb3c95e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d19c7ce5760e5cfa4a5849441c46f576df9f59c2925e3ad88e9b8338b8c81765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ca5b1b757ae3d2d0d83945b5d23a8f3dfe9e5bbdfc7c9254d0bd5a847455b57"
    sha256 cellar: :any_skip_relocation, sonoma:        "5136a7743f143f7dbdf4a172b72f3d6ec3de8fd135ee3524014ec16aad23193e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "343f7f4261807f0fc323e1beb209de38deb6e8261667fee0fbaf3682165b73e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7f4052adef50701bed265ab242589ab3ea6ca3c1dd897cbc4f23c37ab2ee4c6"
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