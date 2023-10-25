class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://ghproxy.com/https://github.com/karmada-io/karmada/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "e3c61a69331fd9643a7530003486ac3aafdba5c58e3b8c921f4af62ebc6ab1c9"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af659e4316241789e085e0f3adfbfaccebba8c30eb5a0e6b05ab4b12b84aa986"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce46258a7dfb3a51554705ecc01d21412269f567ccd70f3cf9f74731e3ea4a86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14cad6e7fb084cfb107f4bc0cc8e4f399bed74bc00abe1a08d03b5d4be8a7f72"
    sha256 cellar: :any_skip_relocation, sonoma:         "f994f81fcacafe2ac93198ff7b276497f40c1f3aaa42b458d6e62194a0aaa9dd"
    sha256 cellar: :any_skip_relocation, ventura:        "7b09013f7cecdbfd98195f0d0679ec077d749a6a4d3e3a8c8869c063607405f2"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c55fb16583280d00882d452991a1b93571e075491fb5892dbec451dfd2a337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34199a981edce2fcc3d9d44de8045970ae46ada27718862191338de8d6810b0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end