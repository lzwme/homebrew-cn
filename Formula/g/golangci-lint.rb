class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.64.5",
        revision: "0a603e49e5e9870f5f9f2035bcbe42cd9620a9d5"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5377ffb4051cfc6d619ee13b123be093afeaac3680917c50e96edd62c2406cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c35e1d881135da4e8f3e447c9cec045e093c732f02a27f3f67ab7ba930a7135"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "617ca927414201a2e66887e56e4a33971ad9202ac1355363c180747b040a1333"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e73a701c4edd0db90cd687c6c2ebdbd4f6e720c587c70664d0d27e666f2d22"
    sha256 cellar: :any_skip_relocation, ventura:       "e8d09abb2185f30e4c9e49b62f16ce8712e8665905f3e156b0b8cb10813a65ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895c554f8dd8cf3f94f4013158c3509c3840b390bc773e939488bbc2ab835c3d"
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