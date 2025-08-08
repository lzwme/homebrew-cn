class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://ghfast.top/https://github.com/wtfutil/wtf/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "9cf809323ff12b9c1499623647fad141dd91d552e5e26ca9ddb8da4a43aed762"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059382377b005f6a5d345316f7dfe7337ad2462c17812753edfa354fd4466988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3802e269e13fc53128fddfff4b2090ecd4b8a4ac655faea629187c6c29da35f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24a1b8263f66d8d9c5482834333b5c32979154f9b57e1ac7abe077340aa9f655"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9c14f4b18db4311e91b415cc0096a96d4ca5b70edaee18a1aff54c06f99e0ad"
    sha256 cellar: :any_skip_relocation, ventura:       "25ec0c238e514e8143bbde540bd47b940346c3177895a18372c567fa12c94570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0c1b1989a06db2fa254bb0c4835ec081e10e27fd47bc604269276f94e0f225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b7b18e226f5dd7bb578ac3563b9de655d98521dd336a0ad8fc52be40ca500d"
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