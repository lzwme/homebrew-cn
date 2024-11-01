class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.11.2.tar.gz"
  sha256 "4ad6e30941fb4c9a37bcea039f1e3eabea245cb6536f0e79cfddc24efd4b8a0b"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db378e650373d6c958adbf7bc3619d33b9af7ab2556cd3093348878c74df534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f51e982c63b5cd50107fdcc91071e61a5a962fc7555c1a985c568d23c997dd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "232ccd229244fb89790bfebcaa59566f942795179d9abdb82dc22a386ed84b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "92914daa6253323fe912fa897b974e15a5cfe5a31757c94dc7e50adfaa32867e"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d7877b8e0b985fb4fc66d8c112482cbe4e2d0c3ea29c832ac41d2fe91c7fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2d376dd64afd27137105e58f31dd6225c4e3381611309a77b3d2e948e630d48"
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