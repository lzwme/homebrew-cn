class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.96.tar.gz"
  sha256 "655087c553a2c008b14b50f44a0832f3732bf337b9f38ceb14979cc0ab870feb"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3fc5e10121682223590ae5b6fcacbdd8eab3438c16cd09d1cefba5747785bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5009a5c435ed5d2629836e047a50f2c7626c6b6bd492bcbe39b27a9e39189b95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cc2688ba1a0fb46223564b4792885ac5be057f3b7825b284374e0a7cc868958"
    sha256 cellar: :any_skip_relocation, sonoma:        "5672d8ee3bb877f8ff608cf25c87c6c7e08d45020601a0f6e91aafd1ffe7ed95"
    sha256 cellar: :any_skip_relocation, ventura:       "9bbd7597f334842cd49614e5056b5726423e21600d679b6d0865f387fce83b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a6a2812aa8bc7ceee1de05b85a5f36dfd8706ebc9a65ef941f9fd2b04afd7e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.comkubesharkkubesharkmisc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.comkubesharkkubesharkmisc.BuildTimestamp=#{time}"
      -X "github.comkubesharkkubesharkmisc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubeshark", "completion")
  end

  test do
    version_output = shell_output("#{bin}kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}kubeshark tap 2>&1")
    assert_match ".kubeconfig: no such file or directory", tap_output
  end
end