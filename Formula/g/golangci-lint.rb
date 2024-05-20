class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.58.2",
        revision: "8c4cfb61097a27266e6673acd3844ff781cbf70a"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6aa02d508f37b4f23869c15a0b9f1a66a459516eaed8a5318a6fd6e277c21ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "140612b28c54c40b12ebe0c076ab9c8953c3ac4d1b989ab6c36310bc8a7a96c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bb0c5a10f98161d2f820429d3aa3d9320960ee0f76e98b7812fa8d0c03daf2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "519126ccd87ef0d5764f3aa4e34f7870aaea0fc1fb5e2477fa0cbf9c4b9bde6d"
    sha256 cellar: :any_skip_relocation, ventura:        "6bd7957335c83c71545d2579ac02a23b0cdc75146cbf9b32ba74c28842d2c349"
    sha256 cellar: :any_skip_relocation, monterey:       "2756252967fd45b3a61c4808d936136e39ed366ac4e53fa5364244a69ca05ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7f6001dddc0f6e7017292f2e065b2a40b3e56a5735d9565ba89bb8c2e57f8fe"
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