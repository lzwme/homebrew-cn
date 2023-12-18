class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.8.0.tar.gz"
  sha256 "3b238e4373a3d77fcea48848ebf2879ce7950513407a00fa767baf36595013e1"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb8d9d7957ec7bf6e6448bae2836a914ea8b04ce4682d978170a7bdab4161072"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964f752775a32641203350713b0ac6dcc0b3ec9873af644574f19953332eba99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c340de7f4595e650b5ee5c8321fd4d60fb42f2029aa05c645e7dc6c51df6bb72"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b7564c51c5ee863b55646e3c6e3ac6f3baed44feafb0d88565b716a88f95a38"
    sha256 cellar: :any_skip_relocation, ventura:        "f30f9a18285e46cc3c86af745885d117b17ac730b0e111843c895d155cb1a35b"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7117ec7fc58abaf4286a20e9e5a801572b5c721910be402b72e8030b3f91d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d06522b6e60ad965aa4e0f874bb7985c59c4706ed51b7639e4c7d6829805f8"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdkarmadactl"

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