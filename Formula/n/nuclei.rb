class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.1.5.tar.gz"
  sha256 "68d4f9135e319cf0e589b80289bba6bd43bd76c4e574b897393104eee17a3b55"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "786594e8e9190b526f86163e4371a283eb925298aa0b9a68af7fe98466fdf2c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e89e2f13ae37481a4ec5c2112734c39345f5d2ec65cc03b99ae1468489610887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19d9a5bb2927e2bcefae9464487481411f425853c3584b150258473b5aa8eef8"
    sha256 cellar: :any_skip_relocation, sonoma:         "60729083d145223da4309737235b6388a6ae4de87821b30eaf73e8f167e1da49"
    sha256 cellar: :any_skip_relocation, ventura:        "4f43fbbcbeb17d69e96d24757605ae4b728b2dc026a20fbd9297e74c83d8ca52"
    sha256 cellar: :any_skip_relocation, monterey:       "8bdb22ba5e55e3ca55d16ecc65e70848941cb98304e7f0e735d973a3316277e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bac4d17a080dbd48496097cc846df9d15a0b020d035efb9a011d964faa410de"
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