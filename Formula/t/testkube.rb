class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.10.tar.gz"
  sha256 "784d6eceb43e21bdf0cb50dc29a62a6ce8c77dbb540efedb72a08c985d2a92a1"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3061aacc28ae29d758e146900e5ccf5f3cabf3cdf4847a50d77fc8980372109"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc35f360acfc75e87e708e4c59854491a2b415fe9ac14420b10a2e16302aa4da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0b1a40403af66a18e7408b43e2fbc12d15cf552b0ca551a6cbbc4998a182aa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4ee3f8cdaffa86cc181cfc7d59cfda2fcf87e0a438cd61c3482136cbe9468eb"
    sha256 cellar: :any_skip_relocation, ventura:        "86547271108ed359a91c33f18bed63fb1e41eb5b8ed26a66c54630e559fadc14"
    sha256 cellar: :any_skip_relocation, monterey:       "5286c28d172391e96e31a98236bdba1585efd588a64d6a64e1db0d5ea2af4d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8ba1277479afcb57e27240819699da7cce0a87fcf635020e2bed36b08458d08"
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