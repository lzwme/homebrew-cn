class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.55.0",
        revision: "de1c391922f0e3792c862f7e8c653bbf3f198d16"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f132d011549f34340a3a75d2ba9e118cfd6b2b278ce36f353910dfd30022b561"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdd891dfd3cb660525564add69d3ff6d87fe51582b8d103e4dba7cf46b40cd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950554ec28749de3cde88f4aa30533ca50dbe330dfdd2afb1f8db11141b489e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c60c65350728ae8b4e04e3a7d73a0d13ff9ef58fa0a652f02836ed502fee939"
    sha256 cellar: :any_skip_relocation, ventura:        "0ab428230577294c786e6be283532a2c3b1aacc89a5ef733d362856ad267726a"
    sha256 cellar: :any_skip_relocation, monterey:       "81535a342c19a9724fc715d78fa9371b56e32eaa51cd52448d45d8fbdf918740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f15772200838e61a0c8cb1a00220253c6c95e52d528a6df0602bb86f7f17955"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output("#{bin}/golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~EOS
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

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end