class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.44.tar.gz"
  sha256 "410724fc14de3470b8e8e24d459f263c6504fdff467642a1f14206272fabf279"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da6d6ce7b251da00d43615c8edeefb55d59616b0c32616cf68fd0f5e3ba4e486"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a928cafa41f03528ed73c1b6e5a6a17fb784ce69b7dbacbbf741f20c81d26d00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c578eaaeea7a347bb0466038eb3453dda1988c9cdd12fab7cb441122ac8ab3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca9c0799b8fcad49e5f695c072ae039f9f1060520b184ff999969c9f4567af33"
    sha256 cellar: :any_skip_relocation, ventura:        "c27cff5fc59efa887ce195c78fcf9d10efc51f7950a9c446a931b51f3c0be785"
    sha256 cellar: :any_skip_relocation, monterey:       "2e48ae2167617bee3ad306574ddb68d9a540659dfc5fe62bc27f5e3185a7d855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2601225409f4013b0cf81af5dfd58f3db8fb39e9cd5d53d81c8c2dd6243c5e69"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end