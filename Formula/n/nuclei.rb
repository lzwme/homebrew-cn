class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.1.6.tar.gz"
  sha256 "c905aa45d1ca367880ac5359c1b84d01b4819f89f47de436c3c5d9fd480252a3"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d24798e64b46e64c3830d8855b71835c5cc666c9f912edcedbadc870ef5620e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "466ba696077b19102c200ca6e230c2d2fa5e43a5277e98ad39f4981cbdd11afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2eab8ebc05bad4e487930e666665df4e4dc1189d1d4753d027d902c21089fb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee44481e72ff83c1fe38532b87cf279d4b1d06642f8f0bb68e7e24f26289908e"
    sha256 cellar: :any_skip_relocation, ventura:        "f7474aeddb1422d6ee51f5a18f7245a02cfacb7a120896623e3d61578238a6c1"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe999cf3db42e9cbf4cce31f55041f8709c217be45c1e61ab2346b24a7e323d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd1ecd317655095cf6d5d13d26aa75a7d27580667a85c397c672a9ebb16ba09"
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