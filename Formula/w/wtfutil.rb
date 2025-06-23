class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https:wtfutil.com"
  url "https:github.comwtfutilwtfarchiverefstagsv0.44.0.tar.gz"
  sha256 "cadf8183be4b84256c50ed64a1a401890016885e305d2816b4293f8494463c14"
  license "MPL-2.0"
  head "https:github.comwtfutilwtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde2bd16f98af0634e758e79203812a6016eecc4cf643ccd8ec3342e0402f0b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e816d26d87f97710245586be7c13c7211b086de42f36d15b9730fccced69207"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b168bdf4b728205ced286a78cb4069b807a762aee32a2e6f1d7caee750241c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b64030eee4547c8620a51bec0b3d4e1f9a444433d7c9a405e046c1830c7d667"
    sha256 cellar: :any_skip_relocation, ventura:       "4f69bff86d190ccd65681f17fcf0e2ad19122889b025cb8efd6040d59924850e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0717b3b082e5edc5b488ff09c6f63e8c7771b24fc48fcb5a687ca24af834c018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3430c5841458efee32a5f14c2166dbb6fa2a3e21e15d04045964cd5ba846de5"
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