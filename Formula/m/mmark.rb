class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://ghproxy.com/https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.41.tar.gz"
  sha256 "4842ed61dc52fcd3325462aad04a66593d184bb69a9be3ba87934dd801e6d602"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9383048659edcaa14ab693a690311981201f73cead7f51a5dd6711eaeecb2d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9383048659edcaa14ab693a690311981201f73cead7f51a5dd6711eaeecb2d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9383048659edcaa14ab693a690311981201f73cead7f51a5dd6711eaeecb2d2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9d72ff655dd83bb2a2b76d9dbf693babfd412942fa16df87c6e61e3f5bbd837"
    sha256 cellar: :any_skip_relocation, ventura:        "a9d72ff655dd83bb2a2b76d9dbf693babfd412942fa16df87c6e61e3f5bbd837"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d72ff655dd83bb2a2b76d9dbf693babfd412942fa16df87c6e61e3f5bbd837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab2a928567c009c55e2093d32f7221506382eea8d38671e3879deae074ea5354"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end