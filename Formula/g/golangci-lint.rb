class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https:golangci-lint.run"
  url "https:github.comgolangcigolangci-lint.git",
        tag:      "v1.64.6",
        revision: "d574f356334437b4210b8289d21af02a817ef868"
  license "GPL-3.0-only"
  head "https:github.comgolangcigolangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1821ce90fd92fdcdb2f2fc13a0e0615312227095a6511033529b6024301ebce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab5fd830dabb184d11e006af4d445d4b4db70b14183087ea98f5b2de2342950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aacaf774a36e6ca9c26e67fe27a4122211da93c49c997cf48bc2e9ffabc38e13"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d1a5777bac55dbab384ca64fa206a160fd0b5f6e5be5ebdbd1514d175b6701"
    sha256 cellar: :any_skip_relocation, ventura:       "47fae1a4432b4205f7b8f3c40b29f8edf5c7c069482cf2e9130e831416bcecda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b17ec72ef63be720f345baa0ef0cd3688fc96edc97ddcb84c5e04c595b31fd8"
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