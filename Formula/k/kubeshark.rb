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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "108b9bbaa4572447be82175540ceb141a2e1959680b69e23a988d8e24494ffd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d427ff15c9cfa0003a0c45099c6f1cf8f49c03e677389d36ae67ab591bee5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a88b63430aec508f0745bc5dadf03e9d9985598243c239489a8817be78dde74f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1bff6e45c5e04889181b92a5e968fe142c89b59f35ae7eb98ba911f1e564039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e174d4cb369e7470fa4965ccf1d940533674d20dde69c6ffdf7e5e9e80e165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6876040753b0d1580e8a5e7f360329832dc48e76232bd54088f057c9ea294047"
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