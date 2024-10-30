class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.85.tar.gz"
  sha256 "ffb323c261834dd6f3b376ecacc4d8759f4bfe40dbf01314afa37a5f1f40ff4d"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cff14d049f0050b1dc0ef4239b50931a9b668455ed19463b64bb6fd98228e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3e743f0ed425b2b3cdb78c9e87f2059c5984fc54acb5394fd3cab9cb22b513"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d1990d6cd057131da27fe97de8b0927a92f105dea4d7ee411fe627fd893d1c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e7a1d12ac09b447d8fdb49b47ff58a83ae0a811a764e06f956e0cc0d7ef9b2"
    sha256 cellar: :any_skip_relocation, ventura:       "6e10ddde52ac790724301dbaa4eeffc92ecb40649758a7e0bf97e867915e71a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61d92326dc54075fcb72c5de8955219b8d6c9839ea054d7d98008ab7c24c550"
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