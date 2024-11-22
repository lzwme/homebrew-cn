class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.11.3.tar.gz"
  sha256 "a56b37ebe5cead776808ed2b35958f15e75c2e5e1733e876d17c14304206cac6"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7798f1719d7495cdf476494204cf269384ca9ddb3f20a647d88c0e97dae2dbb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf1d71dcd45eb2f75ef3cea38932f8eae477af3bf0b69758f0fc689e5c83e088"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d3bc62890c3aff6dca81f89ab6fa24e457b7ab57b24e512843b2c7d489bc578"
    sha256 cellar: :any_skip_relocation, sonoma:        "da6c6d461f2b0e4fdb523274a4407308020411297ee593913645d1fe49a04842"
    sha256 cellar: :any_skip_relocation, ventura:       "21519d361dce80473be31ce03a729a059ea856e0b5e09327925ac232e5285985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea0db056200f0a3f5a487762db0e4009baff6f4a1803338e6175f232ad5160e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkarmada-iokarmadapkgversion.gitVersion=#{version}
      -X github.comkarmada-iokarmadapkgversion.gitCommit=
      -X github.comkarmada-iokarmadapkgversion.gitTreeState=clean
      -X github.comkarmada-iokarmadapkgversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkarmadactl"

    generate_completions_from_executable(bin"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}karmadactl version")
  end
end