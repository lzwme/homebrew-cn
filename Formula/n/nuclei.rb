class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.1.8.tar.gz"
  sha256 "787851dbb19e7be0d8bde8804b7f2f5277f9c676732f762848b17e73ec8b89e3"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7014dfe37b89bcde4eb07b10856d0344726c7e9b041b06c7468246d2389e1c95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f8bfac4b29c18bf3f7ac60820c38166104e566f2ef09e0ac6d7322579e4df7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d156f80673d45e3f70f9468f8905e8512d5f107ff37dc2551ed0989c409b1cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "42039a3461dc1a5ecba71684c0cb1ff89889fbcdc72b6c90506f4313a5fccbff"
    sha256 cellar: :any_skip_relocation, ventura:        "9526ebfc36111cca7fce3acf1d4cc185c85d246e24aececbc8ccbc24e59b7410"
    sha256 cellar: :any_skip_relocation, monterey:       "edf847feee804f1e9eb371420a97301b61aea702c5c5dbad154e2b6376c188c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260e0ba08cb3e10d839b95b974cbe2174183559bc23d4ab10c73a76c76f4957c"
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