class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https:templ.guide"
  url "https:github.coma-htemplarchiverefstagsv0.3.898.tar.gz"
  sha256 "7b957bab2ec9d77a1155f7134429feb832aff6684258566c46d21044bcb97104"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c996089deed3bed467992b73b22e24e93f3f0318ab01a0693e217499a59652e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c996089deed3bed467992b73b22e24e93f3f0318ab01a0693e217499a59652e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c996089deed3bed467992b73b22e24e93f3f0318ab01a0693e217499a59652e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c77ceac08bd26e98c4d1857ee1161e8d52687d92a3bbd4d9a16f793b78778729"
    sha256 cellar: :any_skip_relocation, ventura:       "c77ceac08bd26e98c4d1857ee1161e8d52687d92a3bbd4d9a16f793b78778729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3ae81640e92aa900cea2ed0b25e4c38cd519496a8b6c6ac905e402ec7a76ea1"
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