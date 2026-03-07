class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.11.1",
      revision: "89a46a242b76d9171de7dd96cc3531c8074955de"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5573714e413e70d511f8f4e922c101ae15ba6d701c73d9d907685f280741afb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb52b1ca3bd1d5947d9a17ac4039c3585bff4bd7d1718a11adc34c76b19a71d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46515d170a289fa00980251ce0032f4b16e7e6607145290524e0036db9c03aaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b18d0e0b6c3764815550818daed80f5b977e8af24cb3aefd8c0b5dcb94381a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d8546a44c97da7d8004e11a87b8557dd3809ca8e5219dbe75da469bd1b5ff8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53dd30decbb520b7941ef161fbe7dc67b9973f4b667ba19bb8de8baed0733f54"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
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