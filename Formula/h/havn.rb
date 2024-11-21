class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https:github.commrjackwillshavn"
  url "https:github.commrjackwillshavnarchiverefstagsv0.1.16.tar.gz"
  sha256 "9d66b30e769559c690e1c8cb1e29d7e293b1862d256158cfeb31e8e248ad095e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47cfa7a82ec13d782c92784b43332c875f87c24c0e91bd7897ecc6739d7a9b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dba955a43d9b1c62210a432cce4cba2163d7408fcf0e3230a860782149cdbb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "434e4000c03239a0f72ee70d33614779b4f7026a7e40402edd538915e56c5f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "8561b2925c6c2b048cb631601002ac9c79c9760b4179df3841676df14a849918"
    sha256 cellar: :any_skip_relocation, ventura:       "e5b707dfcf74aad4f0038acf565bf2c0acfb69bcefb87a84e8c5a45001a97dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf3b6acbf584ba869192754e4250e63e6959b1fb21098708818986cf1a2b5f9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}havn --version")
  end
end