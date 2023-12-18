class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.55.2",
        revision: "e3c2265f4939976874989e159386b3bb7dcf8e1f"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ad3d02d43a8b03139cf2e66a9399aa50405e775d0b37ad0876ae9ffde547905"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c331e31283682ff8b646bf16bc5f9e8ed880a72355e48907cfad6d40c0f649"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab6730d78e74e1d7ef09fbdd8c0fc8603c95b127ed15fe8f2ac72a51c77f5cbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "8898033375e7b45295f1dc2b4014ab6096a556b92589bdc6f8b2c9b00d3910c2"
    sha256 cellar: :any_skip_relocation, ventura:        "02058340365944970274bed1004fda9262ad21e260193b446615f866a7b1628a"
    sha256 cellar: :any_skip_relocation, monterey:       "b63759c913ddf54e6e40cf8f9022cba893d0a22c891b56b94599b60b921b4f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36f99def372603d489d6178324482574ad3d538dd6e8a0916e596b5d467c392"
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