class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
      tag:      "v2.2.0",
      revision: "1e7781b6b44db993ba773fce67cd58e942e41d8a"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252ae188101c62d14aedf4e893310b4794967aa40418ca64da307a69469c1c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa01a225cae02a238bc76601b2bb8088fc484c701686579fe91f6a3bcc792a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30724f3227f2f61cccc425faf78d22a21ee1c1e81a72d142d27ea1e2d072ebc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9b6ae9b4d61c0fc0239e8103cfe127fdc18a5880d26d674f639c2fed3b7f86b"
    sha256 cellar: :any_skip_relocation, ventura:       "347f5998cfab53812cf33573f111c4c033be0ba0c0118833ef326bd41643b56d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de7fb1979e7fb482c5295ba1a506d67f8e74e71923789eb562e5fba420cf8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0431fa72220348dc29ba059a761c12b68b362504195411080eb59f12a2b730e4"
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
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}golangci-lint run #{args} #{testpath}try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end