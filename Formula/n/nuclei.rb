class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:docs.projectdiscovery.iotoolsnucleioverview"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.4.3.tar.gz"
  sha256 "3db79d91ab3bf7df021224e193e36a32442232c2a861326bb50492893f3f4276"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf625e411928040cfe6e0d126911999d36f769e457e9e23c509386951555c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3b156c51f194b28785087cb77036ae78d4c23204cc83886e1e245ce69ebb659"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4089527d55eda54f02d44d534639d09a8a01c5e1f73e059dfca3894691b3891a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52448e747ba8fd12215fd8efcc4c927a4be08a821781f7e7aa923459f16f017d"
    sha256 cellar: :any_skip_relocation, ventura:       "736ae50afe2e7a953e6274536504d48a36ae64299a40da1b1f563088661c9cb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75427b9b57cff5d419b2924d92f3f930c0c5abeaf3e8838185e66b40a05e1f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b7ecd0307a71fcb4f43609e417b2d79a3c64444c82249cf49be5112b4b2be7"
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