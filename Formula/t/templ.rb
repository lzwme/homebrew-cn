class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https:templ.guide"
  url "https:github.coma-htemplarchiverefstagsv0.3.894.tar.gz"
  sha256 "9cad117b819d32b05b4c7fe52f6e6562faf1397a070849cfcf1d5ce968b0e822"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa3b5404ca6e568bb82b2b31117cbe60794b8276bddb80a23b7b942383d412d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa3b5404ca6e568bb82b2b31117cbe60794b8276bddb80a23b7b942383d412d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daa3b5404ca6e568bb82b2b31117cbe60794b8276bddb80a23b7b942383d412d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a76428aef41cbfc68d3c2036a1f7b74bac0556c1695f58ea08a53b67a7aa666"
    sha256 cellar: :any_skip_relocation, ventura:       "1a76428aef41cbfc68d3c2036a1f7b74bac0556c1695f58ea08a53b67a7aa666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d060ac3346095d48f45b9bc96439ff77863cac1a86cdcb954cd9f84dd3cfc1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdtempl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}templ version")

    (testpath"test.templ").write <<~TEMPL
      package main

      templ Test() {
        <p class="testing">Hello, World<p>
      }
    TEMPL

    output = shell_output("#{bin}templ generate -stdout -f #{testpath}test.templ")
    assert_match "func Test() templ.Component {", output
  end
end