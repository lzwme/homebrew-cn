class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https:github.comWorkivafrugal"
  url "https:github.comWorkivafrugalarchiverefstagsv3.17.7.tar.gz"
  sha256 "61e5e31baa6eb5e0da9f4233e16be38fbd9dff2004e4f5e0f8bde278e508b3c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02a9a9cdb20a3c04bb3f005eb5a2926c628d04d702a83bc9d124746e1a99b1da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02a9a9cdb20a3c04bb3f005eb5a2926c628d04d702a83bc9d124746e1a99b1da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a9a9cdb20a3c04bb3f005eb5a2926c628d04d702a83bc9d124746e1a99b1da"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6506cc712c7a19a9bf20070d2b7607291776d5e102fc72ca14f9dbcbd76bcf5"
    sha256 cellar: :any_skip_relocation, ventura:        "b6506cc712c7a19a9bf20070d2b7607291776d5e102fc72ca14f9dbcbd76bcf5"
    sha256 cellar: :any_skip_relocation, monterey:       "b6506cc712c7a19a9bf20070d2b7607291776d5e102fc72ca14f9dbcbd76bcf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0447510e8ab79afd02469b2f66fff33c7c9ef9cccbc8bd7e0cf4cd8f31bc27f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"test.frugal").write("typedef double Test")
    system "#{bin}frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath"gen-gotestf_types.go").read
  end
end