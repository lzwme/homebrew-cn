class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.64.8",
        revision: "8b37f14162043f908949f1b363d061dc9ba713c0"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd0493332077be866532e80da705d62f3db59d9a574639aa33fa0e182ce54e3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a7558c6941ed915341ec79ac045ceeb2d0cfd0aeb5f84080c6ac7d316cff69f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "043a7c915393ddd7777f7c7711b25385bcb5a37de1f2c11e7f66435febc3813b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4db1d42ef27da9fed3387ad2f4b73a7e91e29b04d1c1152566f7e51feac0dc3a"
    sha256 cellar: :any_skip_relocation, ventura:       "aac5cafac2bb7942dd9aeefcb9f3f38ff5143bf7f504a652bd40fc122f8c9741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43dae5d2fc50f3dff2abdfc9bd8e15e87b5aad282ef2d74cd1044a559ce35c70"
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