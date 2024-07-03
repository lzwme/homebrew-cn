class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.10.2.tar.gz"
  sha256 "32d38cf18206b46532af994fad730ff6a29acf923170017f619fbc19d1d5aa86"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "536266c1c8c6953e0543ed12012ad3958121605ee583fb0997e6b83e8a27d9a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfdce1d2e465d0a97e75cedfe5de0a0148d869efda6fce4612308fa82f7da129"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d82c01adfe4a63aec38f39f75dd2324da65c39b9d4d6588e94b5ac0dd70c4bdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7b06f9dc86a45ccd5682bdfd1f15a61ba96f887a99739005430067a3e8e4e40"
    sha256 cellar: :any_skip_relocation, ventura:        "ad9449980125904a63b452ca13e9b69d615affe86cff8172be2718f4e9871dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "d88de239e1800b50cf7b138163b82bd88186f733716277610f64e2cf4da88123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a444da115f5d3c6d621d07f97eddb24f3cdb141acc63a79f746650477b64877f"
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