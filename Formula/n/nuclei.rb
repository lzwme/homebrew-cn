class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:docs.projectdiscovery.iotoolsnucleioverview"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.3.9.tar.gz"
  sha256 "2eedcb04b82e8ce973eced74a2e900ab778ddb67c8f7e970b79003271a3db0c0"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50af5bdc870cf0e00ff137d6d03854011b7744a74e18f6322aec6b70b6cca002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15529e294de392646bbf0d8f38b8ed793c45b7a743d4a9cf5cd0c758cf271cb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0fd4af54c44f291500882acf77e44cbc8f2f526da643dd45c1d0c02bdf71b5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fefff501cca7e5b099a6867b00f127940b3a1c3b26d8c10f001ac0f9f2b98934"
    sha256 cellar: :any_skip_relocation, ventura:       "7e3787c98ef6a43e218f5e97da7a9da26a917fa4da1bb0b53f7246ac9970f0d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c46ab40cf44f322a521e8bdbb1fa81f09e99388828c55e9f801feef300b10dd3"
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