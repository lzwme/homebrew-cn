class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/refs/tags/v3.17.2.tar.gz"
  sha256 "a5831a5b077ef5ae363137c559d1d9c1b7cdd3d0b6f3ed86ca08a812cebf4ba7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7643fa69ffd366deaf6bdd07b026eb17caeea036d7ff80469d3cc4db40a76698"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd79b155e9926fa2a4e9bb1fa4a950a5e7be7528ba887b381f9de1dfbae82753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2253d417121f44c17eee18a401fd70d3b1df16cc1ec6638f4b55a5c32eea28a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca8211e7b9852034c4a0148ce00996d38c99c58d7b42aa2e2ecefb3ecaf569cd"
    sha256 cellar: :any_skip_relocation, ventura:        "b43cbf73e4565d179d981f1cddf7ea51b0c1612cd18cc494824b97fa5091d492"
    sha256 cellar: :any_skip_relocation, monterey:       "9eff451c9f640d63ce374b59f870c1cbd2135246567baa152f3e1c9052fe0ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67791834d99c9cea15b7be41a94ca1a9a9b5e0401e72826a47cf275abeb67bd9"
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