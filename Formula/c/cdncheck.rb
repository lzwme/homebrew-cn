class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.6.tar.gz"
  sha256 "f2a6249fe598eedea99d91730d68cfee6b5a33662b59717ed5edd7e07b609663"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5cb06a436c9c7f0dcbd5a31ce6ea773b41230d19e1326f1e130f5d209c46211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33885eb8d88b55d485fee1709486bb8fa43ffe5b3ec3a79bb5b5579c0b99870f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e77f97a2ffffab5b498ee25f23b13f578a0c02e7d3465b9bc987e339806c885"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6bfe33e284bfd1bbdf0bd47cb14af48f980e9a71c0276052df10c8302220285"
    sha256 cellar: :any_skip_relocation, ventura:       "7ccc7cc1b6d25a69bc39361a66f14b84b280762ce6af519a50d0ec33617181df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d65fef934e91d644b4b734c897c06425d671ceafbca43dfd3bb75129a3986a"
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