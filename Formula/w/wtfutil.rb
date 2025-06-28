class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https:wtfutil.com"
  url "https:github.comwtfutilwtfarchiverefstagsv0.44.1.tar.gz"
  sha256 "7cab807c714fc765b85ab62496f5d96770f3bb89117cb34dde3ea668d943314e"
  license "MPL-2.0"
  head "https:github.comwtfutilwtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39aee9c5e14cfd87419a390a215a43133b884928307679d1847a94659fe4f850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc1607a5ec93563994249da99084e1b5634b676a3c671996f6d0e03943493ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b09eedeae268f4c20106139ddda33ffaf049028062d3624f4c0b5a0826663116"
    sha256 cellar: :any_skip_relocation, sonoma:        "713546ff6c93c48d42aab4d4c338e85b1258a063f0b354b71849a0fdbf13d372"
    sha256 cellar: :any_skip_relocation, ventura:       "e87bd244cce21374f596bd269e7e6dda3f12c55a635e277b6475dad3a325ea1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd77d82d2385fea4088cc0690262b57a2d4700649f6e6bd4e9814d1f0b0d7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b215b5b1dfec50f90a8806de89fb0b6703c273fd902bfde51118e9ce27d8b900"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    testconfig = testpath"config.yml"
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
        exec bin"wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end