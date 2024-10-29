class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https:github.comprojectdiscoverykatana"
  url "https:github.comprojectdiscoverykatanaarchiverefstagsv1.1.1.tar.gz"
  sha256 "8a22c1d940ddebad1b857c76edc21daa69f04bc5425c1e78680c05acc236d559"
  license "MIT"
  head "https:github.comprojectdiscoverykatana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591d926469cc2912114357fa56b38b3ce7abd66f353661748673b4137eab7175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f6733ebfbd43ebc273a04aba6ba97bd7ff5c7a50027e733d4a1595a35cdcf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8eb093df19667a3296d38be2fbcfdf0fe30880aaa3917eb587d88bd4cccdfefb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a8b6c66ed3731fbf64d93718c004ab85b6b22195bed8d06a762c87977cb772"
    sha256 cellar: :any_skip_relocation, ventura:       "56b94160bd49f2b9074d5f53eb175e0e592d62a882fb91512725dfe2a96446a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6930774a96299596c233d288bf3b54e0e606651e603982d28000c53abf21cbc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdkatana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}katana -u 127.0.0.1 2>&1")
  end
end