class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:docs.projectdiscovery.iotoolsnucleioverview"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.4.1.tar.gz"
  sha256 "129c36df7fcd9414aedfad44b28ffc5aa3f9abac19495ee1d04e5525c4699711"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81fc51a1a26eb57ac01363af17f8b04a6e63f07becb8d2b67def6ec4d3ae4997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9081a5a1f5b0c3f9de737939b663ae50847f4ee7a82c4f9154632f669fa04f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dea42bed72b586e5fa28eca1066ea24d58ed7d72d0ec27f98a07ca274f0b6848"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d43f2facfbc331be4622012782a8bc928d76a267428c91959ebec1634f01fbd"
    sha256 cellar: :any_skip_relocation, ventura:       "de74ac68f736a24feeed693199d0d535102580ae6c8f77bc3aba217a3a303b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c00f906ae417cf08b4bd748caaa05b00b1f68226abb2c5f00ac42f862d5e66"
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