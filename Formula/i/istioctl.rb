class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.26.0.tar.gz"
  sha256 "1498307624d9cb85d15f3e1892de6cf3d80fdfe888716b05ee4ff25f210c7663"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3b2cecdb78def06f1acf78e5556dcb681c9a14fb497fcd5dddb6e47f5280bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "008e07b52404f9c4dcf2f59e2249c93f119bda704e2a8a39c65b54ec3c16ac22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4560f640418cc7890c39bbc6c76aa7d56f3122073069147696f5ecd055445d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a74cb5635944bf2d2be59b4e39a70649973fd9f8f4ba9c62948b4245ce774b"
    sha256 cellar: :any_skip_relocation, ventura:       "918648eb2bd92dbd6293d491492686433f72b1b22ae276956b4970c010513769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e4307005a3061e32e9193962f7659c6cf500fcff92623cd998c734d08e28f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db14434c5c82f0165723aebf431aa3d9fd3ad10bd97b1e8f2e7d2f24a301e76"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.ioistiopkgversion.buildVersion=#{version}
      -X istio.ioistiopkgversion.buildGitRevision=#{tap.user}
      -X istio.ioistiopkgversion.buildStatus=#{tap.user}
      -X istio.ioistiopkgversion.buildTag=#{version}
      -X istio.ioistiopkgversion.buildHub=docker.ioistio
    ]
    system "go", "build", *std_go_args(ldflags:), ".istioctlcmdistioctl"

    generate_completions_from_executable(bin"istioctl", "completion")
    system bin"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}istioctl version --remote=false").strip
  end
end