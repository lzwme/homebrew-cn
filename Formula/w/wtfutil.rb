class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://ghfast.top/https://github.com/wtfutil/wtf/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "b6c02be79bd6f9a69da612e5a4b99b43d010859f0144085ddfea6a1c60b5bc60"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1314c570c7f004cfc9bb67b942b82e785ce062067a988bd7a3c37c856650758c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f397471eb6934abda16cf404c98088e717a71cdf0c83c231e2f44f68a2521fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba2168c6318ff5795f5613d1bd5dbeb5f159d087a36448b71fccd139dccd5c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "15eaa4978e579e485758fc5a90c44624412d6a7a7a5a87bbb2999f236e59253a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71f4eb01e6245224c034170c4bc778e8ddbf90619bfb60c0d13249b85aa133c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf3449b4f21e79186ef45cd5ac086c40bce69bd51667771855dbdea18aa0851"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~YAML
      wtf:
        colors:
          background: "red"
          border:
            focusable: "darkslateblue"
            focused: "orange"
            normal: "gray"
          checked: "gray"
          highlight:
            fore: "black"
            back: "green"
          text: "white"
          title: "white"
        grid:
          # How _wide_ the columns are, in terminal characters. In this case we have
          # six columns, each of which are 35 characters wide
          columns: [35, 35, 35, 35, 35, 35]

          # How _high_ the rows are, in terminal lines. In this case we have five rows
          # that support ten line of text, one of three lines, and one of four
          rows: [10, 10, 10, 10, 10, 3, 4]
        navigation:
          shortcuts: true
        openFileUtil: "open"
        sigils:
          checkbox:
            checked: "x"
            unchecked: " "
          paging:
            normal: "*"
            selected: "_"
        term: "xterm-256color"
    YAML

    begin
      pid = fork do
        exec bin/"wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end