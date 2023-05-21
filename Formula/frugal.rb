class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/v3.16.21.tar.gz"
  sha256 "dba6e4ae6e880efab3ec593a25860e9994eea8237ea8685fac5f3fd024c5a993"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "478616f83c8b5236f0f439141d08d8a9cf3eab0ede18193e25d90ec116160d5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74747a661d7422a83fef00ec8ce3b00509becdea226b5803647a5f02baaa5cbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "720f0ecb0cd82d591d3bf5c2fc92d7a345b95f082e1f9cb0b794d3bb568c6bc1"
    sha256 cellar: :any_skip_relocation, ventura:        "fc641fb4ef45a776096baa4ad93a4b3baa637c39419c5f51e708e4d3f559c941"
    sha256 cellar: :any_skip_relocation, monterey:       "b96d4acf5ea7e91c185c7ff6a36b02522f847c99d87d5cb856938d1f99b50640"
    sha256 cellar: :any_skip_relocation, big_sur:        "149b661a5da047f681ec1c456943647262c44dfded9ff85207992bbbe9b484cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db204aa08e1a6bf370768c63f0b769398e1744514c39c248d23f069a9de6c360"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end