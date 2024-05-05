class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.2.6.tar.gz"
  sha256 "ac5016e983d65a49da1f7f024e0885738f49c4536edda4e361ffc8c1c442ecf1"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98dc2f8c9e2be8b0e7d1d07f0dd7a2d81a2a3611e53839ac1555ef0eefcbbf8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da8f3ac013211e6f6a911f7df877e477d6a793230cd036cc429112072fdc7454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c364b9b3590bc8a7fb075e93c7cc085f2a070897e88f7bd61f8b1f608b69be60"
    sha256 cellar: :any_skip_relocation, sonoma:         "233220abaa26df1cb96643085944c48301378b0e2c74f485d28d3de67eadc940"
    sha256 cellar: :any_skip_relocation, ventura:        "ce863b52f416f8f519fbbaa40b5b9c5696458856ed22bbb0857b795fe77d90a1"
    sha256 cellar: :any_skip_relocation, monterey:       "b2647bdc3364aa2ffb96046e69971121d3e096996ebf295911696358fca95bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1b364947f340b922b5ae3674a226bffbb0139319af8b7f269786c784543cf9"
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