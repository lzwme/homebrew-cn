class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://ghfast.top/https://github.com/a-h/templ/archive/refs/tags/v0.3.937.tar.gz"
  sha256 "5a56e1798c0e26794ceb18ead9da4b65025b9c2af9d754e59a0ff13df131dd24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6aaa7a70e6813548be9e378c3900e821a83384d9b7a4dc2a4752b9096f66b0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6aaa7a70e6813548be9e378c3900e821a83384d9b7a4dc2a4752b9096f66b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6aaa7a70e6813548be9e378c3900e821a83384d9b7a4dc2a4752b9096f66b0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a71acc9d0b81ae3aaecfbb93ad0831901c45905f23849925e94886648adbd9"
    sha256 cellar: :any_skip_relocation, ventura:       "e6a71acc9d0b81ae3aaecfbb93ad0831901c45905f23849925e94886648adbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71556f6f200302b8b9d50435a5747522623dadbfa75711ead6e8e76e5bcae0a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/templ"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/templ version")

    (testpath/"test.templ").write <<~TEMPL
      package main

      templ Test() {
        <p class="testing">Hello, World</p>
      }
    TEMPL

    output = shell_output("#{bin}/templ generate -stdout -f #{testpath}/test.templ")
    assert_match "func Test() templ.Component {", output
  end
end