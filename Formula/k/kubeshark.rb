class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.91.tar.gz"
  sha256 "90b4c6c223716d21fbce0d8c401929882afe711be60211439aa26f49764f96a0"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85601506de7d4ed26d691e6db22b6ecad5bb867038e99fec085ea694200888ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf61db97234077ee5e909b90995f95fb6fc4082561600ee275ae39d870d669c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85b28a384bfbf073ab3c3a7b4f81e40e3c114697d827bfd0b9650be0bde06e41"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7ed455c3d7684f46476e713b29549d053271886bfa75b2ac51666fc62230886"
    sha256 cellar: :any_skip_relocation, ventura:       "f922c11d61d3daec65885287bc4de8d2994366fee8ff482deeefd0b1eac21ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa5bff07dcfe7102528ce451951c8040e30e2bf2dc158d4fe16c79dcc994780"
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