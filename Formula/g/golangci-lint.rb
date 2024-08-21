class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.60.2",
        revision: "f338f3ef33f0f7b641100aa1fd759549cc959a8b"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04302ead821004fbaab00fe9f93758f5ac10f6745e76b17ad1970dcbd1571955"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30d2de26f2613ea2e76c1e9751e46313d0d84e8fbc6d2c172ef6435c180b5931"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ee6f05dbfbbde883bf51ad9e36e038cce846cc355264814d9cf55607e3a34c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf6b0b1571dc5d34a93f6239f22ba2267c39c8347f6b1208b3f28c25cef35ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "565d09504cf859122e124f8758c6a1f863eac5d355c6111fb7f3fc39979bc36d"
    sha256 cellar: :any_skip_relocation, monterey:       "5967781b834c7910510561b8141a39037e4c87729ada8748abba4fbc2a388a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d5b3be7919318a63b0bd502cbda7c205f7272376dddd5ebedcd5b66159112c8"
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