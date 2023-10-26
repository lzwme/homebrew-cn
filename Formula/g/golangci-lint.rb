class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.55.1",
        revision: "9b20d49dc234cae4819cea4cfd64d0cc507310c4"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d538964526454d4f8b1ab095bf601bd43fab37f95d4d52fca5d4a012cd2a2df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8a3588e7823345d134095988cfcbe69826e912cad50fea2ffaad16b7cfe5e6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db8b11f44eb2151c60d163a85efaeeb27f4887b0e0d1418d35e451cda446360f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bbdd91bf065e905320c51e050aaaa5cf41386acb896d3f4704e8940a8f323e3"
    sha256 cellar: :any_skip_relocation, ventura:        "b9c815da27c6b3533fcbb84b3cd223dece6e7b740a3ac6c76532715e232e0490"
    sha256 cellar: :any_skip_relocation, monterey:       "a7aad3d6901a2f70fe9a87167245ca09bb1e1de1d938c0ce1ba5cb7587500311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6270eb1a19cc1d7002d054533a8aeded82fedbc49d17c8909efd5b4f0418a43"
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