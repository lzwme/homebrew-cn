class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.12.1.tar.gz"
  sha256 "2e5f1193eae5a4178b9f2d31280c5e8569c8364592f426e54662c1dcda3d90be"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "439e1e804fd28efcdb034220525beb462e16029a74fda053780e2340c33c4044"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0be1d9d45b5b420018da60fada8c586dc197bd3a34607919438190668ecacd1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7cc03658643f8f7dd31852a73772792af02fafed9f97b6e49ee41f8becae5d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e341b98e2b3d2fb1ef4418ee2373dd8696e304e3d1b9baf15e2aa86664155c82"
    sha256 cellar: :any_skip_relocation, ventura:       "678c2bfd705a58150a0b2dc656a3985db9a5245e54ff79a474cc88149e7a3897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc326c60e24f7dcedcbaa82206439e57afdf41505aa6a5da7fc8c50c20acdb5"
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

    generate_completions_from_executable(bin"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}karmadactl version")
  end
end