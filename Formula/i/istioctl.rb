class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.22.3.tar.gz"
  sha256 "d0755c3204c9cd8e91b1d1d6fedc2b9489ec0ca6b8f2f23c5c44e39a59336566"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "746868673f19abff0f3116175f5c5cb706bf7653f599da32c3e2ad5c9377c29d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efd7e5307612a9459ba9fad213c3a28e1cc9f0a3e07d62d91fc6f1ea3d802f3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd766cbf6c948e4dfb776d614f93b692fe5cf88c7aa73bb3f05000137ef30447"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac963bef2b3b6bd1f34c2295257dc2e2a2d38fb3e03e3bf75b2a1b54ff8ceb22"
    sha256 cellar: :any_skip_relocation, ventura:        "0214014cad7108a11db1423fba387ddddbef781d4639fc18c07f37dc6a30dab7"
    sha256 cellar: :any_skip_relocation, monterey:       "3d86009d798beb16bb9dcd27c0441d87a321625e7a7043bc22462b7aa4b65c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae8a084fa4c2c45a73a2208022cfe45b4fe00f502d22d2c7514cebce6a9a429f"
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
    assert_equal version.to_s, shell_output("#{bin}istioctl version --remote=false").strip
  end
end