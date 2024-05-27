class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.59.0",
        revision: "2059b18a39d559552839476ba78ce6acaa499b43"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbff897f32c19b4d9964636465c6513e14b1326e8dca4c3cf5a1a7305969d86a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6bea610583bf7da134f3e7a5a9ea0ce45f72fdab3fe30437f0e6a7b81f18336"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e0fc6eb66c2d156098bde7373ccdfac592007692fe241dfb66a457fdda1dfe3"
    sha256 cellar: :any_skip_relocation, sonoma:         "921aca532e68d3dcf8e5b471a9ad96b2d8d13213e7bcfbca353f2f44589fe129"
    sha256 cellar: :any_skip_relocation, ventura:        "328ac27594bbad4ac13b83c257c4685813296e52a1213c06a208580d5cd94f65"
    sha256 cellar: :any_skip_relocation, monterey:       "aa3214af73d81792aa28d57648d190705d3e913665186ed2615f6a22079f0296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e899c99e05ae1dc4bffee5562d5bb04ad0c657d2ebdba8cfbff61fcf21da2424"
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