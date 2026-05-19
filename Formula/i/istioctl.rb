class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.30.0.tar.gz"
  sha256 "5407b940fb5004c5194f9daf36f505667df9b73f785c82e9f33fc0f54c2f5969"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a98affed3368b431b1e3aeeb98a4bcb0a2459ab068d1790859808ac6f7d9b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ea36890f052b893f56fe7010127d83de4202e3b62ff29f62161c7104ee79360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab228467a062278aba96fca26e64d7315d70f7e63e49bb5cf50909d6a8c7a2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b471aac5226154952d79c2cc523c52766fdc7407bf171fef145897bfcd1b2d18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b2affa40da3f84bd68b998070d5c468fff8ec931143d9c6564ad0455d3db1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13015d6f0174f37f290b33a484054074f7b9fced51ef6b71401b7355d66667f5"
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

    generate_completions_from_executable(bin/"istioctl", shell_parameter_format: :cobra)
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end