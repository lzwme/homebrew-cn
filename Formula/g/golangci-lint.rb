class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.58.0",
        revision: "28b3813c887621934c04ed29c75d6dcfbba2271f"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf6727d961b4ff60a6f27dd6938a5a557edf719e4fc052f8cae9d431c7d2becf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09be6c2d6282bfa5c57ee3acd3949ade628bb2e45d9337a06df868b594a2e98f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1be6eef177d9eb49891e3d9bc1bcfac8b58f68328bd691998d325d40574db5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9765af4e6b00c4d5e2f002047fed02fd21f488338f88bc482329db9dc5406cb"
    sha256 cellar: :any_skip_relocation, ventura:        "c46dd1f4908d2945625d0f723eb866cd21430db924ad0802b0176ba98e29ce7e"
    sha256 cellar: :any_skip_relocation, monterey:       "cd4eee0909661ceb46da2d709762f4a5f992db30110ab68f3e960b44163cae58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99028553abe78cd97f1333a980d739279d8af5a223f9d8ea69411ee17a74b74d"
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