class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.54.1",
        revision: "a9378d9bb87e3d5952a7586d1008c6fac3ebd764"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ccd95855d76829768363f312f7e4d16668a77ba571f5a257892d30f2620ae8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "174a34478ed4cfbbf502aea9a4d0476242fb88e66467c78e8af3718e71f25489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34fcacc216b1970dc417441a961417044eceecccb27bbd0629d792b5ae1ce612"
    sha256 cellar: :any_skip_relocation, ventura:        "b8bd2d9a88f4a5fdabdba8d2788ab686c46d5ac8daa900a24bbea5d4675cc228"
    sha256 cellar: :any_skip_relocation, monterey:       "b2d4ed7ca30046905fd12165c628c67a2ffd654118814359a45c864bba0e95c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb3d27e4bf538d10d6d4cb96e2e419ed8cf7aac3f7bea985b75327ea002ccdfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644998665608bd3979336d598466ca18e43328ae9ffd2a096f1e1baa596fbd1f"
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