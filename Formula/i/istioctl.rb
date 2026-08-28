class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.30.4.tar.gz"
  sha256 "907e3edebbff7d99aa0ddf3bb92092c3e69f52973f5a48b1454d09834ebae8fe"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9d12a94f46c5d1455dd20f9c1cb725439b87958cb4dde01f692403692f27a3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00576598d2ffd184c1109d96f305101709100854d4f062da3243da643b2ae4e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bb85c9fa7a31f6d1cf9bfe290c3e0e5dd5d19d7dd26323dce54a993007828f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13702e752349b801c5dcc602a4b67a767facf30b35c54de76fb5aeb1b718d5e7"
    sha256 cellar: :any,                 x86_64_linux:  "0572dfe624205c50067a5da2c42e61764ee6d48a6036962ad8710c2816d37698"
  end

  depends_on "go" => :build

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