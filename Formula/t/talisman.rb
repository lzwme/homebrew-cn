class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https:thoughtworks.github.iotalisman"
  url "https:github.comthoughtworkstalismanarchiverefstagsv1.33.2.tar.gz"
  sha256 "b80ca17bdfd3c3805373dc81dcfa8bc84a1c947c609439d896246a1ccb06eabc"
  license "MIT"
  version_scheme 1
  head "https:github.comthoughtworkstalisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54c0bff3b1e1e3e583a428a20183f62c5f2371ed096bc3f4c70102ec38c9974b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54c0bff3b1e1e3e583a428a20183f62c5f2371ed096bc3f4c70102ec38c9974b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54c0bff3b1e1e3e583a428a20183f62c5f2371ed096bc3f4c70102ec38c9974b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7e61502ed99bc9ac655b52f02f5aa035b2f104e9876303b75b7a2d27336a797"
    sha256 cellar: :any_skip_relocation, ventura:       "c7e61502ed99bc9ac655b52f02f5aa035b2f104e9876303b75b7a2d27336a797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19734b3d820168398d6ff9ec5e94d8dd7211a946da3585a5ec971481ee6376ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin"talisman --scan")
  end
end