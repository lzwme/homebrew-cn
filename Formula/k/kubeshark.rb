class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://ghfast.top/https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.11.0.tar.gz"
  sha256 "dd21fd51fe6a072aa1e39fb929f0f848e4687e4f3fe3d65b9e019ebf83259e97"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bbc48eb89b51a5b3a5e3090c0ae5e98e041b1e80f8d951ccd059bc2ed2cf58c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c87c5c8707303933d4ff239d561bbf3b8c6ad8121bf5bac4f1e8f35fd1756c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31df1747521a214ead66591769cc3af06f5d48af380a8ca82ed8addb145e52a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "743a52337a2ee33e6c8abdaa33f9caab899865ad650778ee94bdeba69297ad69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb06a7dc204c635d29413d80d511a66dd3e35a0a1bac1a1dd050159045b5f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3bc8db5afbb7316177d93fd75f6b8ed3117ac94b1ccec8a6a9d4922ce7f28b"
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

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end