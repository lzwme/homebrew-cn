class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.3.0.tar.gz"
  sha256 "db3136b86699b0f42128b96585c51a2a6b8cbe88ac6f1d69a845d704375042f8"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b2827feb9446062a32d4fa1052ebc7c47043b6f975ba012ce97c190f04299ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ff54305a4857608b119a7e995339bae68a2c9c750f018f7018b336d03d61521"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb062ebc085caf3580922faaa62fcd93c30d9ced22a9114d10472cc54ed8fdd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca9d86f1ff299be6462c9c7c5997bdf371431486cedf0035526c8217cb727ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "e37f9e993dda87116d70ec96da10dedd3b872611b4c9fd61f2025d342a63783c"
    sha256 cellar: :any_skip_relocation, monterey:       "7515ffe5366dad49b20f31895fa8ea5196927da7c5da1399048b1ae44e343bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc8ae5159fb461c64c344dedad8512850f9ebdc5c06601f3bd2e75ad39142853"
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