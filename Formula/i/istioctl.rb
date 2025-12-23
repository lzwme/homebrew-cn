class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.28.2.tar.gz"
  sha256 "ee4b5d1ce045c98e09e97bce2e48c2d1ae262ae02db8829b5b1f4b3e546b0874"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef42a0632b6af75db64ff065bc21a33cbb46483bbd177450df76432fb9bfff8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea7b6c79e478e57cb6741c9e1bcbe71d8a62c9ae157b9f112aa52bfc9918c111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "296132b574a4aec02d870e4895f6ddc7cd35f1ed5c8359d92c60080bd530d741"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7e28e6311b409168f45a2d1813daba3f6cd6128fef08c44eb910b797bcbd58e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6a18efdd894b67a681621f6d2eed2626621c090f319a9cebc74b4a1bda62a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f88ca2fa254e557a138658e6facd6cf626f26d54166117aba5e9ccc55930069"
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