class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:docs.projectdiscovery.iotoolsnucleioverview"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.4.6.tar.gz"
  sha256 "a621692f87da27f2d86bd90f8d1234c5b8648db697e8993d76ae2067023864f6"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fbbcce977db9abe6466ece134e5fa1f59621db83dfab9722db8ee150b88d287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ce33150bf2937cc0cdb98cb73cfab9cdf0de6899c4cf0fc0ff4fbc8ebffed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17e5a40e67fbe0bfc325d322e1544076232116247286c998579771d0f149ef19"
    sha256 cellar: :any_skip_relocation, sonoma:        "117ff361b0b8c848c21f451eac30bbdf3d12a113e96d95e4dc87564c75d16891"
    sha256 cellar: :any_skip_relocation, ventura:       "ceec465cd5d6f0a8327207d38219dce502a0620969c825e452b6373206841b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c55270d7d8dc34bbfcd707d6e27ace6494fd72166db9f5855d3ed52a870e04a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bad1eb3d6f832b2defb94109d43814fe6082c0e40fda155fbe1e78a68dbdb994"
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