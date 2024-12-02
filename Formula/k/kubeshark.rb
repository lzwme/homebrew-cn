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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880494eac12160398dc63cf785473705f1b39d1d7b5cb7451bfcfa3bba48b764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d715b44991809427469c2895deaea153c5d8b2ea851941911978a76640d5bd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f42f0f379eb3c3645b3e5eb7a1ebddd211377e6f987d025a080a7d2a991c466c"
    sha256 cellar: :any_skip_relocation, sonoma:        "35871b2272699a20924fb0e490f2073ebccc82a04fa09dbaa492ee11943b1b2e"
    sha256 cellar: :any_skip_relocation, ventura:       "234c35810aeccdb35a83d2a68ce8c9debccf87e2ebec809efffec84d3b581e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb544a5030d33c65f1d966859ff6078112120f919bbbc1a609525fb4340c2141"
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
  end

  test do
    version_output = shell_output("#{bin}kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}kubeshark tap 2>&1")
    assert_match ".kubeconfig: no such file or directory", tap_output
  end
end