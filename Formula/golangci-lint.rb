class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.53.1",
        revision: "e5243324a620daa5f0b52231f08526eec60597fe"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "357ddabcd7fc653b4f5b71ae2f49f189f8294fe38dd989e1b8176340a24ed07f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caad59fd94d628b103b30b385b63288c040cbe7e30a4995a4cc28e7dae76a894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2df03ff7c1745375057cc285929453d6cc9496a248fd36a6842c8af17dc0ce22"
    sha256 cellar: :any_skip_relocation, ventura:        "9698908e173c7daf760d5069eb26f25e9f3cba3edce96d615f84384d59512c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "ef56d117c0a9e05be934d1c6594373da60cfa3cbd24521dff7a172828f887ecc"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa9940c9879bcb7689fc19e9458a6e86a33a6446fc3e933a342cc6cf20410ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b04f4da4a1029d9f6fe8929956240fe7a76bac0e43f984491d3f3bf051d1146"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output("#{bin}/golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~EOS
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        return
      }
    EOS

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end