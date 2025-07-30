class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://ghfast.top/https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.8.0.tar.gz"
  sha256 "82de96b7815befc3a0ae329b44149072c3c000a21f2d89df9410ff0d3266db01"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db1b84232cdbbe69c34ded3222030de6b535f097bee9092727437d70973b4a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1ab1045d045e648047321933aa20cea43631ff32eacbdbd709a8bb060282f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3adc3a9456ace822a8859c50fcc8c1b3263161d112b3d06f3e6f2fe4450b045"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f71423a1fcd55ce827b18bbfac4f0b610b31c257875bcf83ccf2b6707c72f45"
    sha256 cellar: :any_skip_relocation, ventura:       "b5fd2cff3c43a1fca4366c86eb8290e991d4da24454828415a047e5d071b1375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d438773ea971007a84c4edb4cf12230298b854c9ea167531593a68d48cb696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe12c8dcb0868c7d493c22243f7f2c978249e8f958e1bcc64621fea0b2a214db"
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