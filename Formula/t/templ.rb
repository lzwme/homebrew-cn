class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https://templ.guide"
  url "https://ghfast.top/https://github.com/a-h/templ/archive/refs/tags/v0.3.920.tar.gz"
  sha256 "2a5edc684d6af133312d5c745da6fc825f5bc73bea346ed404df233e06499573"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c2e0034c2eca7c965829466c2fafe7fc3b1932f2b820c214ebf6a9f5df9c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c2e0034c2eca7c965829466c2fafe7fc3b1932f2b820c214ebf6a9f5df9c5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46c2e0034c2eca7c965829466c2fafe7fc3b1932f2b820c214ebf6a9f5df9c5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f73aecfb68c2520909960f47d7edc0ff1c4e90f18fc0fa72029187d120da2aa"
    sha256 cellar: :any_skip_relocation, ventura:       "8f73aecfb68c2520909960f47d7edc0ff1c4e90f18fc0fa72029187d120da2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed469e5d249b83d9f882b2b38e0975df0a770d30966a1b2fed87b8b76220528"
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