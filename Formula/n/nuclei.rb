class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.3.7.tar.gz"
  sha256 "3d12498f90b4babead541578f095c8f8aac7d08038073f0f239142356d3a4c79"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf2f0facc6f57692cbf11ebc5bb15580bd1566593ddc122179244371b4ab4bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7aa542abecde162792f487b057421bd990c9c36fccdb3f281382ec27110d749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a62a62f2b7409c4652be25ab611d258de3f320de6c5a2500af4db4c6b7d6cd93"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c6dbcb75e61ba5de3471028775a7d2db6b58cd04842a7a47a9c13b8f1599997"
    sha256 cellar: :any_skip_relocation, ventura:       "e80a978d3471d7c5dbf70e3bdc4abbb1eb141bb7c5e251ee123cd085151c19bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650457610e325b268e964e590977eb54456dccf7961bca36de0550307c32eed3"
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