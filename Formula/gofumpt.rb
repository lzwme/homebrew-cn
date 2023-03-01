class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://ghproxy.com/https://github.com/mvdan/gofumpt/archive/v0.4.0.tar.gz"
  sha256 "ba1fd89dd5a36a5443c879cd084b5626d3f8704000ec53c0d1cf5276af2bfa86"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac2f60dfe7a39ba22310052bd021d6a9bdf82fd73487c1655427718ee755fba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac2f60dfe7a39ba22310052bd021d6a9bdf82fd73487c1655427718ee755fba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ac2f60dfe7a39ba22310052bd021d6a9bdf82fd73487c1655427718ee755fba"
    sha256 cellar: :any_skip_relocation, ventura:        "55dae3df15d489825e9218c2e6c37afa71490bf74415976549d1998b9b7d9be9"
    sha256 cellar: :any_skip_relocation, monterey:       "55dae3df15d489825e9218c2e6c37afa71490bf74415976549d1998b9b7d9be9"
    sha256 cellar: :any_skip_relocation, big_sur:        "55dae3df15d489825e9218c2e6c37afa71490bf74415976549d1998b9b7d9be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc732483cca12c6bdf11a9a5d7f9435a1093511ac8f212fe7fed45bfcc7e8a35"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # upstream issue tracker, https://github.com/mvdan/gofumpt/issues/253
    # assert_match version.to_s, shell_output("#{bin}/gofumpt --version")

    (testpath/"test.go").write <<~EOS
      package foo

      func foo() {
        println("bar")

      }
    EOS

    (testpath/"expected.go").write <<~EOS
      package foo

      func foo() {
      	println("bar")
      }
    EOS

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end