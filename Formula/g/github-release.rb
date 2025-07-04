class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/github-release/github-release"
  url "https://ghfast.top/https://github.com/github-release/github-release/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "79bfaa465f549a08c781f134b1533f05b02f433e7672fbaad4e1764e4a33f18a"
  license "MIT"
  head "https://github.com/github-release/github-release.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0b20b25f60ec51bb4b9a017a9f3e4895d9a8e0a7d8998d54ec15c0e077e365d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "341e850b66904e4eb870de3b926284f56bbd6f40f33491c28c0f96623d85fa5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9813355bc2c269f5729efb5e212522d9aa876f80ef488c09a3c8e7d69fac2c90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d85d8888a8214690922cf085ac5207ee2fc34b15da2d877691955db4819cc68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfaa0f4ae21d44b1e0716ef71cabf02ac60a8692893b2a49bb32e096cb441a4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea137b1f95b412d6cdca3ea7d8c4173afd1848ebe8ee9833462e040e5417c279"
    sha256 cellar: :any_skip_relocation, ventura:        "353e7edcd5c8952b49878c1c264d94ea8be756fed3e3d098199abb2802e15756"
    sha256 cellar: :any_skip_relocation, monterey:       "338994c0481c0f4ab4523a29b4c1c7c10553b621ee7921aa3aa7d36bbada3b79"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7770942546f2a49c7b44104fe69ad7cf724cc1eac39280d1217af66ccd97e3b"
    sha256 cellar: :any_skip_relocation, catalina:       "6dc8bf5543967949480fb9bf3f24e149a5ef52857cc38877125f9ad6281eeb58"
    sha256 cellar: :any_skip_relocation, mojave:         "745fcc9458243936c5e482098357c5f83d44e5126e5346f1f6c6ca90ee55a4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a0776dbf6e7156af66a6ce7aefff22e5f12ab47f310748fe75fa6aba8edd3d"
  end

  depends_on "go" => :build

  # upstream PR ref, https://github.com/github-release/github-release/pull/129
  patch do
    url "https://github.com/github-release/github-release/commit/074f4e8e1688642f50a7a3cc92b5777c7b484139.patch?full_index=1"
    sha256 "4d7d4ae04642ab48b16ab6e31b0e0f989cc7750dc29123dc8164c629b9523c2e"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"github-release", "info", "--user", "github-release",
                                            "--repo", "github-release",
                                            "--tag", "v#{version}"
  end
end