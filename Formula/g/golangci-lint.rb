class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.56.1",
        revision: "a25592b52a064adbebd7f54f8bfe055171eaed9d"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2089e79f5712086e9a39de4a44ea51558be3e6bcefed8d678b327d3d68fec8eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fda78485a38530c7897960ec37b249093a9e7977fbf6b27468248c4daff0b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e247d8539da7c7643310ef8c58c5df55c91420995d297e7ab4e683f0101a5d17"
    sha256 cellar: :any_skip_relocation, sonoma:         "df812c6e7673c855058db337cdb0ff9c9d7924c67a00b2fb59fd36b24e8e07bc"
    sha256 cellar: :any_skip_relocation, ventura:        "7ef771979fe0c9dfa26ed5b58b6a11628a7b555c6bcbfe18c5c3339382ef999a"
    sha256 cellar: :any_skip_relocation, monterey:       "7384ec8b66236bf4aedc7d24b5cc36952316c60cf83cadfbf19fbe5c34b99a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c737f0a3d83bbfb1963f77bbc2fbbd3f9fff40fb541b6d50ec224ab5f5760b1c"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdgolangci-lint"

    generate_completions_from_executable(bin"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}golangci-lint --version")
    assert_match(golangci-lint has version #{version} built with go(.*) from, str_version)

    str_help = shell_output("#{bin}golangci-lint --help")
    str_default = shell_output("#{bin}golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath"try.go").write <<~EOS
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
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

    ok_test = shell_output("#{bin}golangci-lint run #{args} #{testpath}try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end