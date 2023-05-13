class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://ghproxy.com/https://github.com/Workiva/frugal/archive/v3.16.19.tar.gz"
  sha256 "58da90281fae2aa3478e4baf1422ebab2c69d747f20b632e81fb12c7d8135c7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1a2bcf90a916fec796a3b413dac4726dfd6ce6481e70305bb4d3b2a17402472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4d2c4566535e7d22eb127099f7429d593ed381750b33a58893b98c94e00feb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b01082b445ed61312389244341df50e1bd7b855d08f037d33963c39d3d25449e"
    sha256 cellar: :any_skip_relocation, ventura:        "b5fd59855eae8677bf94bfea4cfdaa1cf09296b82f5f41bf1eefedfdc79c7fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "5c00fe1786f0372fb87d69f14d239bb8a05f77ad3c783dc37ecd30095f714577"
    sha256 cellar: :any_skip_relocation, big_sur:        "96bfac28350f76019e132b06afaab1bd530a1590df43c91c2a52d00848dcbc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be8a9967c426681f040abead40a8deff8a5102e717dd070e6b28710ee811d19"
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