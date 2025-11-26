class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://ghfast.top/https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.10.0.tar.gz"
  sha256 "d5367ebb017f6ccdd5d6b8b864bcd4d33ddcf59df5016f5921677f285e13fe91"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b575ccec6c22be7204b65b82d4f317b6862184ba0a4669ec4a121c91c42c25aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efbdfca85506400b2e039da8845bebadb1068db5ec494e4f0780362847cc0a1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1505fa881671c7c24794c08767d0ba0bb55924ed809fd3176fd6065cf585245"
    sha256 cellar: :any_skip_relocation, sonoma:        "b39d0ad56f3c19c8cec67fac0b612238e656165919b402b3bbb2d997cf1823d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5946c5fd8bae9ee8963ca8f75b2c92e04b1df411a4c1626f70a1430870b90064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3280b1982b1f36cef690bbc5903e755b97e718f3165601916c9db26f3a91726b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeshark", "completion")
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end