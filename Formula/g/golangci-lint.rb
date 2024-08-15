class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.60.1",
        revision: "3298c104802d118670a487b330ddd3761f7afe20"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1c947276dfd39ec3d3520b8923a1d02b7d0d88aa38465eee9a0119d2f6422d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "427e5cd55931eab5ab3402793ddcb728647f5bbe1ea24b5fcfec49f47756861c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3443f15cd37f1df30ed820376604fe948f1f6719d8cf32b0ef0f8dbd478b36d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8ffd0f550b010d8fd8d0b1902027f90083d8e9093b76ba0bdaabfff7c5c14f5"
    sha256 cellar: :any_skip_relocation, ventura:        "445bd96c15418f766812f63934a96b513cba60797e4cbc33807658ca76de0c56"
    sha256 cellar: :any_skip_relocation, monterey:       "85e7d26050a20993a91a55433dac27789897ddc2375fd4ca95e5c41024b5e410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98cc56d1f9d57ac035323b5edc5f1a568df748de0afd9349692bdeedba89496b"
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