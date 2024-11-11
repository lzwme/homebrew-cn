class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.62.0",
        revision: "22b58c9b648f027d699f305c069a2a97ed0c5b06"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "814b5a41db9fdcc3d0bf55c91883a43beeeeb7cf60b281c378e938dccdb6b4e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb6d339e514937b0e0838c78719fe4c5ce58e8ceddc33b87ada76bd4ff0157c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fb0f0f2b1937146d0edfc54d669dc093d5ec648849d4a81a1acb276992ae4f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "364cc6aaf0edf61edb428a41b224f443b999315822c4fc8f90c270124d6637d9"
    sha256 cellar: :any_skip_relocation, ventura:       "a1de93fe46479b5a02c628f60f155b1ac271c431ccffa6686d4b22f8d8dcc0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a67d039b23f4be0628a93539d4dd61242aab681feccba3fa4b52fba34632483"
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