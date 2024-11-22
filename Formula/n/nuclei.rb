class Nuclei < Formula
  desc "HTTPDNS scanner configurable via YAML templates"
  homepage "https:nuclei.projectdiscovery.io"
  url "https:github.comprojectdiscoverynucleiarchiverefstagsv3.3.6.tar.gz"
  sha256 "7fb42cf5c9c4fa8800d40a997466dbfeac9954e1cae8d98a7af25c19801eb113"
  license "MIT"
  head "https:github.comprojectdiscoverynuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1600bbd80d7ae1fdd980022008d4b214c84553acc09ba5c375f4d7312f9e8765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31b8247e96b04a3e1ceac6d2510acb98c8e6440526f2cdfdfdc174807854ced9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c083b0c0a474983ab925cd337e689dca59938fa58bc36c85e7e596ca69ce4c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "898ac62856f9bc6374fe26e1b0b5218e604f0c67e9988c075a0dc695de7423cc"
    sha256 cellar: :any_skip_relocation, ventura:       "fc2d69cf5842a8fe07500fc46acf09787b44c17304c6080da3e2ab1c5cf70fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6daaee6f6ec205a28d080ba4795df06223fa12795b1edf83f8cada7295973ef"
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