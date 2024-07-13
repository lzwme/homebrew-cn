class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.10.tar.gz"
  sha256 "37ced860bec9207a119e65f0f6e4091faa0fe8d0041faf87d91063f314757ba6"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3f92393e73bd75156f0f5133585e70cabc3855906a79bec4028941cf0f40c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aafc5b8184204afa172853de780130dcd4f44e38886e72a694bbf8eaf4a3780"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "234c6b3f886c33b22c29a388d4e3d85686b578bba2ba152e3c013c97741aa07f"
    sha256 cellar: :any_skip_relocation, sonoma:         "76721a30d07e1eb1dc2cb509503e87432e0798ad601a4afe00cf03ca9de7c5e9"
    sha256 cellar: :any_skip_relocation, ventura:        "33a692583e670b832a1a354944ebfd3dea5cd055f77e6fa62f859b644eb36733"
    sha256 cellar: :any_skip_relocation, monterey:       "9d45fc469da518b98c4e43d7014ce9d9e2173cb277f5ccc0b6a81eb246bb8dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbcc451450ee3fd9d4ba840280994d047116f43b5870763ce49a382edb3e50be"
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