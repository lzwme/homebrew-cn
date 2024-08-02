class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https:mmark.miek.nl"
  url "https:github.commmarkdownmmarkarchiverefstagsv2.2.44.tar.gz"
  sha256 "c2bab6fcb68fbf2c1fa0763948d0d5a18f00734b29d0f4b1894ff1991739aff7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acb13a00ba530e40a58cba93e5cafeebbe66d2ffa3e9e753536acfadf0615e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acb13a00ba530e40a58cba93e5cafeebbe66d2ffa3e9e753536acfadf0615e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb13a00ba530e40a58cba93e5cafeebbe66d2ffa3e9e753536acfadf0615e1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f7f5fc40b7ca933125c35925aadd83c9a1067d99897aa49db335479d8ad2c5a"
    sha256 cellar: :any_skip_relocation, ventura:        "6f7f5fc40b7ca933125c35925aadd83c9a1067d99897aa49db335479d8ad2c5a"
    sha256 cellar: :any_skip_relocation, monterey:       "6f7f5fc40b7ca933125c35925aadd83c9a1067d99897aa49db335479d8ad2c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12230718cfdfa561fbf1c263d3c1b58dd38701f239192374f4e86ead69dfa6bf"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https:raw.githubusercontent.commmarkdownmmarkv2.2.19rfc2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}mmark -ast 2100.md")
    end
  end
end