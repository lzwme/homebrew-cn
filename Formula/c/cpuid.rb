class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https:github.comklauspostcpuid"
  url "https:github.comklauspostcpuidarchiverefstagsv2.2.11.tar.gz"
  sha256 "879274b71c36b718b245187a08a3ef717bd41275fa75843de9434755a31396a9"
  license "MIT"
  head "https:github.comklauspostcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1372213b08a4965139affeee0157e343805d80adc6ec727ed1feaec5f5370c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1372213b08a4965139affeee0157e343805d80adc6ec727ed1feaec5f5370c76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1372213b08a4965139affeee0157e343805d80adc6ec727ed1feaec5f5370c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c1af9ee43ec37ea032847a7f42dc203a655b792606d708ef205ed8eaa719ef"
    sha256 cellar: :any_skip_relocation, ventura:       "18c1af9ee43ec37ea032847a7f42dc203a655b792606d708ef205ed8eaa719ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0e528e28e5a99a5d6af40c0510f1a7a8cfb9017124459ceeae8d6e22142a965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c84d9f6d0e4c33bfff7f12e5d189051bcd4164213dd220ee521067e7ad18c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcpuid"
  end

  test do
    json = shell_output("#{bin}cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end