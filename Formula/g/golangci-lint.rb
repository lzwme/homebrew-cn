class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.56.0",
        revision: "1a00b409a8179b7ebb0618928bc1fc997b1a20a1"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e24f4932038ccdc6d3be6a706a79f6402b0ecc6bb0a20caaca045177ac09f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a6dcef8d57959833ed226524279c1d56ee481dbc9ee8968e280f704d350053d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c46808c946b1036f11fcbae62b217027cf12b3a0f62ab92d86108cec8a96f6ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "98528308020b97df0a661a1d95a482535d3b86dbfeac86465176ccd2464a9a7f"
    sha256 cellar: :any_skip_relocation, ventura:        "09c48ac12853d33fa7bdab0f692d564e6086d0830812ab95b3126cd428f92032"
    sha256 cellar: :any_skip_relocation, monterey:       "25e1a1c9392655b9419c986b51a35225b4f3a692dba9ed67aaa2dc415aef69d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f2d4f6560c5500a80f8d182eeebbf0c0fdcf5fa10b4ebf50d51f8ee8c15b1f3"
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