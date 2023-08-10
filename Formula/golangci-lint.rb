class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.54.0",
        revision: "c1d8c565fa4b92197257b68f3339d7a5e0a07486"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cb3a1719a0a20f93b11190752a738bac20a03614c1d1bfcccc44997a84aec08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5377dcf0fb0eab2b5d0816175383c7db80840dc88b46e2a131e32a89b4da412"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39f2c03e399423f91df067710ff83aa31ea2b16558accbe5642fc4a5c2037b19"
    sha256 cellar: :any_skip_relocation, ventura:        "2154fdb901b72571d97bfdef3a7f38d0051ba859bfc2c9bd0c016e8fbd6d60ad"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3d90d634c8bfd535ba0595dbffe530756af4529f79ccdb7f17f558c65609b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "80a5d8379df8cf2bd6f871b2ddb73c38e52740bfb3e45ec2eb37e5deb7f7b2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9997eab1ff47eb98a624912822d0bb920c9bad83482710d0a40d2a0682f9265"
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