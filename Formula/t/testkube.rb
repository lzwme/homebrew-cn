class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.11.tar.gz"
  sha256 "f3ea0e42110d4dfd2768e2e9a2c49812256d2e9a14ee3c3f892fc210d6e77352"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0679276d96f37f70b1967a1fa01b365881c2066800d3985bd993265ae990163"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae179691ffb2baf63b6d0ee4678bc15921ee467e7228e5ebe8834a3b8a3fcfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cf21d079e24fdb33ed106eefaf8d2abc17e79e3733f3dfd80ea4a569a3fcd8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "411a04769a03a6ee41aaead70a92ea09ea0a9f43900bf86790fccac5b90cc58c"
    sha256 cellar: :any_skip_relocation, ventura:        "7040fad84024cb839673d22d38066200d80d0df177f34e05229d4e20ad9d6ebb"
    sha256 cellar: :any_skip_relocation, monterey:       "42c9b33cef673e0d57ec840223430ba716d310fe3ea30be448f6de1b5411a87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48eb2e30629643078f1029f3e9e24c538aebc7d191bf57b464a82cf35f8c2d55"
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