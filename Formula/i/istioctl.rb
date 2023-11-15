class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghproxy.com/https://github.com/istio/istio/archive/refs/tags/1.20.0.tar.gz"
  sha256 "0f8cd89eb76d840e4ddd39a415f4142858d1bcb310f4eaa96be998c649bd1959"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34b5d7ed60f7f15fc7e4323a81cbfb241140975e6e165d26686d99a9c20b801c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d847a434804b20ba558f76affd450b4fa57a0d58ad15f6f9bca123cb0a82cbd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83870d3d5c0a0e4c07f861885062b14fb2b1c91137dcae3fd47b7311adfae514"
    sha256 cellar: :any_skip_relocation, sonoma:         "9abe001eb3bf0b9f788860607b3b91fde60446a1310c0b0f39d487e999790bed"
    sha256 cellar: :any_skip_relocation, ventura:        "f272ab3128df7430c917495f82898f4e4538c9fdef1be952d6ce939dc3093d37"
    sha256 cellar: :any_skip_relocation, monterey:       "f34c9f3c4f43b32f177c0bcd3db8fef5463924fe2e036ff8c3ce5edb425fa495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7b90dbb2f239cca088e04bd461ff9d873351a0c3f4d18407d30e3acf7da4081"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end