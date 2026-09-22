class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.31.1.tar.gz"
  sha256 "ca78a0afc0bbd7a4ec4dfc53833daed009ae86aaedabfc05c467974ad36358b3"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a4987c5eb865b685fa559656a514cc36011a2485ca6871f02c6b5234f50f170"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a98c38e6aa91d587711f501f633928e35e1727a0ba2f033a8396cba48580a670"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb88680e0635f39b5562eefe4fedbc93824b2ec40a70f5cbf60122577d479518"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50cc94b16c7a56c831cc71b691ceee706ca4ba28efabc0a0ef0036509d087a03"
    sha256 cellar: :any,                 x86_64_linux:      "aef9db819e0ad81ef0a053070504ae391be38232c7c074fc6d5a0915b2aabb50"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", shell_parameter_format: :cobra)
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end