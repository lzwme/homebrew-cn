class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.60.3",
        revision: "c2e095c022a97360f7fff5d49fbc11f273be929a"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "009d19becfc0e627de9152407d3c99383a888ccfcb14e97ea5eeca09719bf4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "602d0f80ddf11d5c9b65d7245b5c587dfbb0e649f057812cf2de3d63e133b3ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb01b187ca312d81ec73c9902b74ce7fe88c5ba558e6c725b0d3a071dac7860a"
    sha256 cellar: :any_skip_relocation, sonoma:         "db786499d61ecf9cedb653a68b19b105bf3e02326ed09fc2da84e48f6e962a12"
    sha256 cellar: :any_skip_relocation, ventura:        "1f109a4764147bef87adaedbb22e5940a2da4f2b001016ed6ce47768ee298408"
    sha256 cellar: :any_skip_relocation, monterey:       "e2fa9bce45f4ed63933bd8973813ee179fc57f9cb8fcbc598ea660da30445606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddbb1b03ef49b35a680c9fa6298756cfca693a416826baf7fc4bbe156e18c901"
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