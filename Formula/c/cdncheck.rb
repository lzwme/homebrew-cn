class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.14.tar.gz"
  sha256 "4750c21d54a91e8cdd9d73c85bcd902ecf2dd29f975230bbbdaad0adf76d5ab0"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1851bc4a44f45233971ce8b0235bfdc07e7a9e5d9632dedfbc30a25475063a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04b1f758fa5e863600873dddc82ba11f811524ec874aba20b79b4bace9616a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d933e2cfb01f8b7f58d3eadfbeb5068a188d8baee0a905a80e91093125d7c561"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f92bc1c44e05cfc2fe6b3a33bdc004498cca12f6ec7880df3c0a6caa77324b6"
    sha256 cellar: :any_skip_relocation, ventura:       "cf9b9119e4f83752c982e31a7314ca2836714c48c220176e961fe69ad95b091a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60440dea22ce4783d046933c24f4b36e6bb6b91a6fc2979b40b5805ff30e7172"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end