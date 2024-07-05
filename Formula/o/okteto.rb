class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.29.0.tar.gz"
  sha256 "4c94ba838a3dd7840c2d8103675d93520f770ff8fd460b23f73f9d13c993efa5"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af84c92fa8f436a73e31188c67b00585769fc8b5963e008e6e9f8f8f35910a66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f10500e8869339d74ba10cc341b493146ec2462933e0754bf729d6eff8fe8d74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41ae5b297d2f6170f4a930630b9eb1b0b3a5798a046e56cc675d9d221e5d761b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae912b9c39a5a091979fe9b57d1d9423f6e8d867eb66f571def8f506fd2a787c"
    sha256 cellar: :any_skip_relocation, ventura:        "eba5b5ca2bdf9cb652d685c899ff95b838b606644eb7e4154e6a5d1607047c04"
    sha256 cellar: :any_skip_relocation, monterey:       "6d7a71e4a0c1662e2d07093defbdbe96f142521f0bcf173728d7dc1093194a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9645a47c0cd24d00a201b0219387b727850a8230e44044643001f686b577ab13"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end