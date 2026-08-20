class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.13.0",
      revision: "f838df1edb6265abbfa24f5cbb7381b21c735642"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d413c50e30a291c9cc5f3237f117e8b179d4546cba40a19d0ee15e6556791e8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3d4ef1aff9bbe10e6bd74df1ca1fb80618efbf09d325c4a08d41a6f0a7e0aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d57195ef4e50f0d6b7761a9df596c7f5b0394316eb51e9486b8c627efb349eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "12f0fe256591de96514e06b9194459e0efd4aca86caef30b33ba6c940d5f4ee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e847f946c139c7c1fa64985d6560eeb208c37a9ff351890090c955b16a17dc33"
    sha256 cellar: :any,                 x86_64_linux:  "541d8eb028bef306c33a99c76cf2f088edeb2dcc6b08aa1ff2ff17a76c579ddb"
  end

  depends_on "go"

  def install
    ldflags = %W[
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