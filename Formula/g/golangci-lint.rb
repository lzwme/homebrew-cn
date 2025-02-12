class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.64.2",
        revision: "1dae906b28741887b0364c09d01d68cca1a5cbba"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43cc9a9200d371c21a594a6d6ae4eae012d4789e5c976f727e1cf8f1cde58c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e989f111ecdcc112b1d5ef15038d71bd0db20494e207330ef152ac8ddc1d3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "423554fba1a9d613941c5beb2bbd02dbc8848d7e6f74884e1c5345999ac5ac64"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dd80fa1dc44db28399133849394a2f67d6c42ced81e019b521c8ae4b90a2466"
    sha256 cellar: :any_skip_relocation, ventura:       "4397f9a8023913e8e65f31060df23cab60ebd132f7ac0fe33034d54d055e8222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02db421f7b4381d46c925762fe434d9070182683f3f0476ea0423c9e64ab1e24"
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