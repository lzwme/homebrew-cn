class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/v3.16.16.tar.gz"
  sha256 "b8ab71f4f683778ab86dc12953a9ae8247e416d6fb51b75d70e5bb0d29655552"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c284a1bd1f1ab95c628dbfa2b575a28ea48d989eed333da21c681e60624ae3c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c0b58fd26b6306bf8cb68a485951f6634bb58c387bc168f193a9a43b1af4554"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60e27d8a3bb65464d28bc3200287d6d2ffce29a6d988a879d4a042e1c800649d"
    sha256 cellar: :any_skip_relocation, ventura:        "3408de964e152cd5e8dfdae9ee39c0e1a8cedc4dd09c90e4ad4a7f1655dcb8e9"
    sha256 cellar: :any_skip_relocation, monterey:       "fd4da7aacd33ef7b5b1b416a474ffe34b8fa30cbcfe47f9fae0667ca44d26745"
    sha256 cellar: :any_skip_relocation, big_sur:        "203b73d74acb6fdfd7b6eabb8969432c3474bd4dc4a77114bc9653ba5fdede8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a4ea68f525222e5515e042d048d5a2bc5e05e7feec028485ab26228916efc59"
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