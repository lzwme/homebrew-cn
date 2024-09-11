class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.3.2.tar.gz"
  sha256 "193657ec42c9b931e911ed67d8c8ba1e4047651d75bfc855951e47ec06bd20ff"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ea35fdbae26a3e2d2cf35ef70769c9ed74ef2b0fc7bf10a0db849c8535ef5503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d71eb9067058f45098b3a5d08654441b14869d1e2410aaa2739c74eb4321f201"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13b3c3c8a9a0cef8637a4c95204977e0ecf3edc49c9766bcdaea14127529ed76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea14e85dce8c0368e4bd5b73367c65c57abaf4b3fe7f500b766e55ab171805cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d736e4d405e158d7b5c061268661c4a63f095156e2a91ec21e2f1b0b5bddaf8c"
    sha256 cellar: :any_skip_relocation, ventura:        "7f76534648b2f4f62be12312cb7f1cc8886d292e4125638b293e901e4459abd7"
    sha256 cellar: :any_skip_relocation, monterey:       "a6adbb69619780f7d3b1274a7a6af083d7735204e8f06dd4f6575a4e77975174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a7748c3c6c17946415dc713ad754110a4cb6eb67ea27d89f7ba5f851d044943"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdnuclei"
  end

  test do
    output = shell_output("#{bin}nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}nuclei -version 2>&1")
  end
end