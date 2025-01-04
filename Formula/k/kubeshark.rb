class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.93.tar.gz"
  sha256 "6e5a867b708f46a0c0de26db3caad786c665c7c154e49250afc49e7a8c4d7a40"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec5ac35923cfc42085dea6d2510e5e1d5d20e25add6875dc9f373e8fd49027f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24c0235bcfda3cd9c63be0e69ab975ee308f00419b473600e9edec799cca8a69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b9ca31cc776b27e2ab1a757aaeba2246c9d5653dc1d6e6d0d8d0d6a84a38823"
    sha256 cellar: :any_skip_relocation, sonoma:        "4923b814d80a94d3ff6710dcedc228f33394043226528d1cab9f232f08e994ff"
    sha256 cellar: :any_skip_relocation, ventura:       "4abbd9b76269bc0778e3fa532068af49f07824ce475ace08eae0cb38f9012c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae89bd96acebf1e89bfeda9c3e966b7d1d6b4568343bf893db98d5d1383514f7"
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