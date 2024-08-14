class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.60.0",
        revision: "1147824c61441fb1a928927ca095aa3d0f208459"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e716d60952598f87bc739f1c2597f0eb3dff7003ff3c59b2a6a73f5cc8ffdd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a68a5aa2fbd1dc3a185ee5c3cfbb988c6f87de1db6bb74e40324576c2f1b5a2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1f2caf7177ed9763413f4e9991d573188437eeefaddbac4508251d146b4dd25"
    sha256 cellar: :any_skip_relocation, sonoma:         "363cb00b3db0a45d15e33cc0cea95319fccd3f7ee4fbdf2cb9aaa8a76313e159"
    sha256 cellar: :any_skip_relocation, ventura:        "f172508e8bec41da51844d90affd75215835d3e0e8b54d31736305eecbb549e2"
    sha256 cellar: :any_skip_relocation, monterey:       "b8e598304738f54d76479b4e035f2cbe6d75c1ada38c2b92f78f773c19702e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80f059eb54cc14d5a4052dd7f76077b6bb6523320f9d1d6468df7dd464c13011"
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