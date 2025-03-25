class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v2.0.1",
        revision: "e8927ce25c6178656a803d1edf35c9f3abf384ac"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65f66ede8e43df8bb9d853ee57571abd25eb4fd2336b2b4c012d52cb8de3539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360de1f2b13aaf02055b2fb4a4655427cd34276c29db51939ed5ea5ad8edeea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "740afdb8bf47e5ab1773bcd5bdec0feb46aa4392067428618cc13e448aeaad2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b03153b3494fe9fd82f2449820b61cc6e7145501db953b181d6863414ff71bcd"
    sha256 cellar: :any_skip_relocation, ventura:       "fa680dd284bb1e5db2a40d835c07d5dbbd03b874b7c3432cae6d81b474c6eb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6dcebfa94bbab81063bdfd20b02fb717ebea107e58c82396b998b1173f3f6a4"
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