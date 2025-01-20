class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https:serfdom.io"
  url "https:github.comhashicorpserfarchiverefstagsv0.10.2.tar.gz"
  sha256 "bcccbf847024af099e164faf6d6d111345edf166eb24e53e3ccc7f37d6e281a1"
  license "MPL-2.0"
  head "https:github.comhashicorpserf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13e3b04200c7af32b917a447452939a6dbf82ebc40e7937465e4150c2fa2418d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13e3b04200c7af32b917a447452939a6dbf82ebc40e7937465e4150c2fa2418d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13e3b04200c7af32b917a447452939a6dbf82ebc40e7937465e4150c2fa2418d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6d6ae5c6519299a5066731b9a37a7503453400849633423839d85cdf80e7d98"
    sha256 cellar: :any_skip_relocation, ventura:       "d6d6ae5c6519299a5066731b9a37a7503453400849633423839d85cdf80e7d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd73aa1d5303d52c424bb871db029524e8f64619c0aa0dfd1bccde4f9d023211"
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhashicorpserfversion.Version=#{version}
      -X github.comhashicorpserfversion.VersionPrerelease=
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdserf"
  end

  test do
    pid = spawn bin"serf", "agent"
    sleep 1
    assert_match(:7946.*alive$, shell_output("#{bin}serf members"))
  ensure
    system bin"serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end