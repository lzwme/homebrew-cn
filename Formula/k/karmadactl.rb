class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.10.0.tar.gz"
  sha256 "1a95f2759ca98ea8e0a52db9ac61895df33aa1dc9753cc46c51ffadf3a59e781"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e20dcff09de1de8c33439dfe13e5d1bd393587be5d23c4fb43a9d7b0c305c58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38343b7a5f91e62d93af934091685f348de58b35b2f3e1db08e1a59b91e7cae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "958846a2099ea6d245fd35d0d96dec94901835b93fc3319ca8b45a85d55953ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "2981e39ec9fcb44e193db69f8d52854b9eab16ce28d8b8287459b2a2cade43ea"
    sha256 cellar: :any_skip_relocation, ventura:        "a385244ded976dc28f43773e6daeddbd1f007ecc5cd929d3060cb6d2bff7bd40"
    sha256 cellar: :any_skip_relocation, monterey:       "31bd928c6e0f080ed41b3d39b280fa4737b4070ea261f06574225fb32eb93874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86e1dfecbcfdd4ef757d451febc63509d9003ccb0af4f44615e02b04da338605"
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