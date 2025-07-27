class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://ghfast.top/https://github.com/a-h/templ/archive/refs/tags/v0.3.924.tar.gz"
  sha256 "d8102d60d4122f2c319bbc9134c1bed4bad962d33f456049ce876bfe8fd76cff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d10a5623a57a1ae2b09e86243e34ebaeeaa7ce98fa23b54f8cb432cf2c039a50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d10a5623a57a1ae2b09e86243e34ebaeeaa7ce98fa23b54f8cb432cf2c039a50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d10a5623a57a1ae2b09e86243e34ebaeeaa7ce98fa23b54f8cb432cf2c039a50"
    sha256 cellar: :any_skip_relocation, sonoma:        "627f633643a69d551bd149ca22b4fc32e2a41773710f4b2aa801b355d5f94824"
    sha256 cellar: :any_skip_relocation, ventura:       "627f633643a69d551bd149ca22b4fc32e2a41773710f4b2aa801b355d5f94824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7efc4cbbf7950319465eab573ae225ab389abfbfb0bbfa1966777174b8a9e7b"
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