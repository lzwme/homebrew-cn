class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.27.3.tar.gz"
  sha256 "9ee30662d906de1b02c9c0578d52fe079e0db42235c1193503b956ddd2d9a815"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "790282accda81310194c420fad408a847f9e4cb612a9684ca9bbf98ecdd13eb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d44c1cc0df8c37a52d5e140d0352c3fb7496defe1376ef3913baba0e7db5de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6270c797491b5b6a353600700d505b5dc41457825547ebd4cd2cff7e00018d35"
    sha256 cellar: :any_skip_relocation, sonoma:        "71aacdb425d901313561a340514264c91145fe9c29cfddbc7cf4e08b5b216544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7db2606100cc9081e7bb7ce0c9dbbdc176530c254eb9aedc90f9b467686b3abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16b14bab8e2a847dddaa31a4210dcc81b191bb09ba01448e57daffdd8b74ada"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end