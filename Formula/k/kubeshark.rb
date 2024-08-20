class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.78.tar.gz"
  sha256 "4316a161600c7cbb995018a4eb733d226a6d05c20d4640cab3f518089b741f28"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64fdfd53fed8b2e4de8311cf2e1917ca0cedb35373e167af181e69a9742d179f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d321f4d4b1b479436d41322b7ada7a88cd22bd51df8acc08acccd2e7bed7afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436e6f82335846d63955497f3ddc24e9571d4533799fc7f33e0d8df29c0db6ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5876489febee2d5b307eee64f447e1f971a41a934a6d8f99c68efac6dece302"
    sha256 cellar: :any_skip_relocation, ventura:        "d324ce4250596fa4d3dbd31a1b1e1ad84bcfaf7b7bd0322067e414fd42a1e515"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce1423aee5ae2eca8f075c6ebcf9f9ecbc582fd94eb247399a738a51e5967f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3143f43153a53cfb9807272595e49c5a8b775ddc4c4fdc33ae2009d28bb23c81"
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