class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:docs.projectdiscovery.iotoolsnucleioverview"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.4.0.tar.gz"
  sha256 "80c1c98abe37b59b884b3c2fab190d2eb73196f9871834dc51360af04044965c"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782f0c41c8ce52e1fc51dfba10ed0512700389fb5955b22eaf5c834faba55fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3cd415fc829d11685628fbb9a6766a6b8eabfbe0cd81cf0d6848ac82956190"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "105790752b0cb9f0cf2ba38fc635c5344fce92c8778676d377bec2b171bde860"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d102eb316483edf81cd663c5ec8e7a9c7e025f50097cba19dcabf638a299c6f"
    sha256 cellar: :any_skip_relocation, ventura:       "13acffa9971969d2f0a87293b321b792250caa7b8c1d18292364e296afd04bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59bef91307997ada1df3b4085c23f3c8524046b642504ceb313c36b4c1d6782e"
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