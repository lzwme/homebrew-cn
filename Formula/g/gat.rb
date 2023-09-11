class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghproxy.com/https://github.com/koki-develop/gat/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6c45e7fc0aa307ded9f8c2a98c6d1e9e21356a01e1a0436b13de4e937d9a0d9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9b9b420ed2027b99f85482f9f15dc4d23480bf9c3853c21a6a7a61da52df8d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c7bd1ac47c07ac3522939bb3301511566d6e65cec259d7ec8157619d40901e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baf22f6928aae70dafc9766a25f2df1a77e839f2b250ae71556dc9b8a9b85396"
    sha256 cellar: :any_skip_relocation, ventura:        "3e08af4dfd200cbaee0726968a8b32acc82a1d234ad48c204ff440dfee624abb"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9658c8b426abfcd83fbe61978f7da4e738df85a5dd2f0e9d90e3c77593c5d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0beb7b8411aa0d187b7d308ec93917a72420d8fdd38e82ba05083500c1c26a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8794634a40be3e5e532cbb299a89c6fb8d03666042baa6051faa80798c06a234"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end