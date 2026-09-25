class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.14.0",
      revision: "114493f9b3e7257d29e4130f2b4a4aadefbb6845"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83ffa541066a5b71b17b9c0284d15f0efa0e1883c50812a52d9f1e32bdf6dbab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c770fde66e040d094b0406b185c1d01b8f7b864eab679eb29dea6e055b89da5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e773a1238a07404a6fca160435732611610b07a0f6864dc002d2738084fa12d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff85205ba85a289146271488b79e7f8c1c7a9453a51fbaad983d24bc4a097c88"
    sha256 cellar: :any,                 x86_64_linux:      "6c670de3b67196aec15644fe5e136f944a04436c666db82d383a5bda579e0b9b"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
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

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end