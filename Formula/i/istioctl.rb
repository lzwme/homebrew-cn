class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.24.1.tar.gz"
  sha256 "316886f4a5a72d54342dd6a2bfb5e8bc26af29e37d7045870aa95741558a8690"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e64896c30201dafd9e4005c49d75aa87706bd67dc87c5beaf7c75f7285e8b3e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e61460f619970dd99bfef57d3bd959928d445f3331d25ebbd426d0d8d2f869"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fca849f726fe9ffdbdeed6537207f655934b4a31d8ead64e33f77fc2a945a6e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c104c73a44544f2fa527a173d3b4262837835cf273074e2feb9b0292ee96f85"
    sha256 cellar: :any_skip_relocation, ventura:       "399b6cbfdbea5970ffb3fbec6225ce9f5fff45df9c3a10492c9f6ae97784ef25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae3b188609668bbbbc02408a4dd89ac37f7d3055e4a3a6f2dc027a36838ac69"
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