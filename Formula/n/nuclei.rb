class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:docs.projectdiscovery.iotoolsnucleioverview"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.4.5.tar.gz"
  sha256 "5ea8c1f1fc932032328c1f864a85db65715b12b62a9f3ad0bb5b37d3363f2e1c"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdd055992f1200d06c02dcd1e13aa2d3467ba59c2914a8a95860b03386c2c5c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ff098746e2d05944b25745d8e02dfa1f7fff400e776528c4f384e59dd3738e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80735bca3e07fd181e40221fcdd45fd37572c464ecb0626c31a4c63e95e627da"
    sha256 cellar: :any_skip_relocation, sonoma:        "25192f0d8f54bb57b0bfd134f24883180dc721b083e4d9df12620074558822da"
    sha256 cellar: :any_skip_relocation, ventura:       "bbf72a30055d85238ac6b8a625ffae55fb843099e7c3c37a53997a9b16aadd2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c81e61d030e2c302477ade72b914b61b565867c322c004ca426791afa27ebb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1531b2b681f13a07ab53c1e50805b0634a06df8676eda20926d5897324c5fd"
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