class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.63.1",
        revision: "29809283a2eba3fb77007a50d76668998d13f0ab"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46ebd536db97e93719f1192a7cda03918693e05f3dcba0ba9d770b10562f21f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442a236b3636d66806a9b3d29e8a18e4a074b9f63c8f79f85d7058d176f0c697"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3abb30540bc30178243c4f98aa08362189f91068099b09e96d66f9b43eb5f26"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3feb251487aad91e118a00904dd04b046f0f80a6059263380eba48aed05911"
    sha256 cellar: :any_skip_relocation, ventura:       "5890628566ef17538f01bf697a9c1a1156251b8560a16acbf47524b8b13a5bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f6cd9d31c7a7f20e18f8098f4da4b18e269b465ad9562a4d79aae9bda6e4845"
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
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}golangci-lint run #{args} #{testpath}try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end