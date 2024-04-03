class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https:github.comWorkivafrugal"
  url "https:github.comWorkivafrugalarchiverefstagsv3.17.10.tar.gz"
  sha256 "e4b692e7f5faa4de7901382af0d207b6e8ff13dbb03e8baca83551f4cc6415be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bac6575ae0b0e70c60e690295bf51317f931032cceb395a70e8f110708b76302"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bac6575ae0b0e70c60e690295bf51317f931032cceb395a70e8f110708b76302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac6575ae0b0e70c60e690295bf51317f931032cceb395a70e8f110708b76302"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f28533788ca012f3edbeec22ba0d98e54f0e4fe38bf6eae0eea2eb33cb4ad63"
    sha256 cellar: :any_skip_relocation, ventura:        "8f28533788ca012f3edbeec22ba0d98e54f0e4fe38bf6eae0eea2eb33cb4ad63"
    sha256 cellar: :any_skip_relocation, monterey:       "8f28533788ca012f3edbeec22ba0d98e54f0e4fe38bf6eae0eea2eb33cb4ad63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac89715583a55556543fe9be706b7c8b267b7e18a1506e46393f00f877ae28d4"
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