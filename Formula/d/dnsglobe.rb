class Dnsglobe < Formula
  desc "Global DNS propagation checker TUI"
  homepage "https://github.com/514-labs/dnsglobe"
  url "https://ghfast.top/https://github.com/514-labs/dnsglobe/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7e63f170acc2af62923de0c368b3c7d95ef9851b81f5b53c82bd529595def523"
  license "MIT"
  head "https://github.com/514-labs/dnsglobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5796861b7a196f634812edd09acc13aae0ca8aa56a306deabd00379aed5d0526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "735add78828594599af16d44d3bc6ed9e4ce07f7471030c679473fe8692893ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04c09ba360db088b094acd6539ce1189d703f1202f4732065984afbd37b8866"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d2f105424d64eddaa316bfee2cca4304a6f75b678f099dee3618859c7329b59"
    sha256 cellar: :any,                 arm64_linux:   "d5e04bd675c8182592d4ed6c928ac10606e2a318b86b38fea8568d006472b507"
    sha256 cellar: :any,                 x86_64_linux:  "5a6c58049d2f7bf3c9ade5815be961472415222095b62006a7da2912e8494adc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsglobe --version")

    output = shell_output("#{bin}/dnsglobe --once brew.sh")
    assert_match(%r{propagation \(\d+/\d+ responding\)}, output)
  end
end