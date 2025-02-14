class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.1.tar.gz"
  sha256 "f94c62d4f4b1b5cb84c2cc6a465d364b747b585c8f7522f10a6983f26b318236"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b98b2e27061e8ebf22a7625667a3c9f9489330735d60fcb14ee51d53fe08243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d9f26d46ae4123bcdd840b9f1a94a73c42e49fcd027e21fbe9e392f9e9dcab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdbe0a1551b6813b1f9d190fff1ec388dd5cc12dc87939288c401bbf36c9c71c"
    sha256 cellar: :any_skip_relocation, sonoma:        "745f96d5edd38a3f67da29cee0a9c4b32977c9b405701948a04add71de6b1a02"
    sha256 cellar: :any_skip_relocation, ventura:       "bc6856a7f455b221b71611f31f33cc51720c939f870512bb168a4d7819b579ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff7fedd41ee458172e0e158ac47fc41f9c70489d89d082b8d2acc72459e7d5c"
  end

  depends_on "go" => :build

  # Fix for incorrect version. The commit was made after the release. At the
  # time of the next release, ensure that the commit updating the version is
  # part of the release. Remove this patch in the next release.
  patch do
    url "https:github.comprojectdiscoverycdncheckcommita1c2dc71a1cf5c773a9adc44b2ae76bc041cc452.patch?full_index=1"
    sha256 "2ad6e32682eb4a74d838087fe93b5aeb7864d0b982087e18a143a68278f6fca6"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end